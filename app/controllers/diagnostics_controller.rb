class DiagnosticsController < ApplicationController
    before_action :set_question, only: [:show_question, :answer_question]

    def start
        clear_scores #スコアをクリア
        @question = DiagnosticQuestion.first #最初の質問を@questionにセット
        session[:diagnostic] = { scores: {} } #セッションに診断のスコアを格納するためのハッシュを初期化
    end

    def show_question #idを使って対象の質問を取得し@questionにセット
        questions = DiagnosticQuestion.order(:id)
        @current_question_index = questions.index(@question) + 1
    end 
    
    def answer_question 
        #params[:answer_id]で選択された回答を取得しselected_answerにセット
        selected_answer = @question.diagnostic_answers.find(params[:answer_id])
        Rails.logger.debug "選んだ回答: #{selected_answer.inspect}"
        
        # クッキーでスコアを保存するためにupdate_scores_in_cookieを呼び出す
        update_scores_in_session(selected_answer)

        # クッキーで回答を保存するためにupdate_answers_in_cookieを呼び出す
        update_answers_in_session(selected_answer)
        Rails.logger.debug "セッションに保存された選択された回答: #{session[:selected_answers].inspect}"
        
        #次の質問を取得し
        next_question = DiagnosticQuestion.where("id > ?", @question.id).first
        if next_question #存在すれば存在する場合はその質問にリダイレクト
            redirect_to question_diagnostic_path(next_question)
        else #存在しない場合は結果ページにリダイレクト
            redirect_to result_diagnostics_path
        end
    end

    def result
        scores = session[:scores].present? ? JSON.parse(session[:scores]) : {}
        Rails.logger.debug "Parsed Scores: #{scores.inspect}"
      
        max_score = scores.values.map(&:to_i).max || 0
        top_categories = scores.select { |_, score| score.to_i == max_score }.keys

        top_category_name = top_categories.sample
        Rails.logger.debug "Selected Top Category Name: #{top_category_name.inspect}"

        if top_category_name.nil?
            flash[:error] = "診断結果が見つかりませんでした。診断を最初からやり直してください。"
            redirect_to start_diagnostics_path
        else
            selected_category_name = top_categories.sample
            selected_category = Category.find_by(name: selected_category_name)
    
            if selected_category.nil?
                flash[:error] = "該当するカテゴリが見つかりませんでした。"
                redirect_to start_diagnostics_path
            else
                @top_category = Category.find_by(name: top_category_name)
                if @top_category.nil?
                    flash[:error] = "該当するカテゴリが見つかりませんでした。"
                    redirect_to start_diagnostics_path
                else
                    selected_answers = session[:selected_answers] ? JSON.parse(session[:selected_answers]) : []
                    Rails.logger.debug "セッションに保存された選択された回答: #{session[:selected_answers].inspect}"
            
                    spots = @top_category.spots
                    Rails.logger.debug "絞り込み前のスポット: #{spots.inspect}"
    
                    if selected_answers.include?("新しい家族🐈探し")
                        spots = spots.where(foster_parents: :recruitment)
                        Rails.logger.debug "新しい家族🐈探しで絞り込んだ後のスポット: #{spots.inspect}"
                    end
        
                    if selected_answers.include?("子供連れ")
                        spots = spots.where(age_limit: :unlimited)
                        Rails.logger.debug "子供連れで絞り込んだ後のスポット: #{spots.inspect}"
                    end
        
                    spots_with_high_rating = spots.where("rating >= ?", 4)
                    Rails.logger.debug "高評価のスポット: #{spots_with_high_rating.inspect}"
        
                    if @from_question_path
                        @recommend_spot = spots_with_high_rating.exists? ? spots_with_high_rating.sample : spots.sample
                        session[:recommend_spot] = @recommend_spot.id if @recommend_spot
                    elsif session[:recommend_spot]
                        @recommend_spot = Spot.find_by(id: session[:recommend_spot])
                    else
                        @recommend_spot = spots_with_high_rating.exists? ? spots_with_high_rating.sample : spots.sample
                        session[:recommend_spot] = @recommend_spot.id if @recommend_spot
                    end
                end
            end
        end
    end

    private

    def set_question #params[:id]で質問を取得し@questionにセット
        @question = DiagnosticQuestion.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        flash[:error] = "質問が見つかりませんでした。"
        redirect_to root_path
    end

    def update_scores_in_session(answer)
        # セッションからスコアを取得、または新しいハッシュを作成
        scores = session[:scores].present? ? JSON.parse(session[:scores]) : {}
        Rails.logger.debug "Initial Scores from Session: #{scores.inspect}"
    
        # 回答に関連する各カテゴリのスコアを更新
        answer.categories.each do |category|
          category_name = category.name.to_s # シンボルではなく文字列を使用
          scores[category_name] = (scores[category_name] || 0) + answer.score
        end
        Rails.logger.debug "Updated Scores: #{scores.inspect}"
    
        # 更新したスコアをセッションに保存
        session[:scores] = scores.to_json
        Rails.logger.debug "Scores Saved to Session: #{session[:scores]}"
      end
    
      def update_answers_in_session(answer)
        # セッションから選択された回答を取得しselected_answersに格納
        selected_answers = session[:selected_answers].present? ? JSON.parse(session[:selected_answers]) : []
        Rails.logger.debug "Initial Selected Answers from Session: #{selected_answers.inspect}"
    
        # 選択された回答を追加
        selected_answers << answer.answer
        Rails.logger.debug "Updated Selected Answers: #{selected_answers.inspect}"
    
        # 更新した選択された回答をセッションに保存
        session[:selected_answers] = selected_answers.to_json
        Rails.logger.debug "Selected Answers Saved to Session: #{session[:selected_answers]}"
      end

    def clear_scores #セッションを削除
        session.delete(:scores)
        session.delete(:selected_answers)
        session.delete(:recommend_spot)
        Rails.logger.debug "セッション削除: scores=#{session[:scores]}, selected_answers=#{session[:selected_answers]}"
    end
end