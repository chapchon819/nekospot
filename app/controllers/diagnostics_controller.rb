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
        update_scores_in_cookie(selected_answer)

        # クッキーで回答を保存するためにupdate_answers_in_cookieを呼び出す
        update_answers_in_cookie(selected_answer)
        Rails.logger.debug "クッキーに保存された選択された回答: #{cookies[:selected_answers].inspect}"
        
        #次の質問を取得し
        next_question = DiagnosticQuestion.where("id > ?", @question.id).first
        if next_question #存在すれば存在する場合はその質問にリダイレクト
            redirect_to question_diagnostic_path(next_question)
        else #存在しない場合は結果ページにリダイレクト
            redirect_to result_diagnostics_path
        end
    end

    def result
        #クッキーからスコアを取得しscoresに格納
        scores = cookies[:scores] ? JSON.parse(cookies[:scores]) : {} #cookies[:scores]が存在するかどうかをチェックし、存在すればJSON形式の文字列からRubyのハッシュに変換
        Rails.logger.debug "Scores: #{scores.inspect}"

        # 最も高いスコアを取得
        max_score = scores.values.max
        Rails.logger.debug "Max Score: #{max_score.inspect}"

        # 最も高いスコアを持つカテゴリを全て集める
        top_categories = scores.select { |_, score| score == max_score }.keys
        Rails.logger.debug "Top Categories: #{top_categories.inspect}"

        # ランダムに1つのカテゴリ名を選択
        top_category_name = top_categories.sample
        Rails.logger.debug "Selected Top Category Name: #{top_category_name.inspect}"

        if top_category_name.nil?
            flash[:error] = "診断結果が見つかりませんでした。診断を最初からやり直してください。"
            redirect_to start_diagnostics_path
        else
            @top_category = Category.find_by(name: top_category_name)
            if @top_category.nil?
                flash[:error] = "該当するカテゴリが見つかりませんでした。"
                redirect_to start_diagnostics_path
            else
                # クッキーから選択された回答を取得
                selected_answers = cookies[:selected_answers] ? JSON.parse(cookies[:selected_answers]) : []
                Rails.logger.debug "クッキーに保存された選択された回答: #{cookies[:selected_answers].inspect}"

                # 初期条件を設定
                spots = @top_category.spots
                Rails.logger.debug "絞り込み前のスポット: #{spots.inspect}"

                # "新しい家族🐈探し"が含まれている場合
                if selected_answers.include?("新しい家族🐈探し")
                    spots = spots.where(foster_parents: :recruitment)
                    Rails.logger.debug "新しい家族🐈探しで絞り込んだ後のスポット: #{spots.inspect}"
                end
                
                # "子供連れ"が含まれている場合
                if selected_answers.include?("子供連れ")
                    spots = spots.where(age_limit: :unlimited)
                    Rails.logger.debug "子供連れで絞り込んだ後のスポット: #{spots.inspect}"
                end
                
                # 高評価のスポットを絞り込み
                spots_with_high_rating = spots.where("rating >= ?", 4)
                
                # クッキーから@recommend_spotを取得
                if cookies[:recommend_spot]
                    @recommend_spot = Spot.find_by(id: cookies[:recommend_spot])
                end

                # @recommend_spotがクッキーに存在しない場合、ランダムに選んでクッキーに保存
                if @recommend_spot.nil?
                    @recommend_spot = spots_with_high_rating.exists? ? spots_with_high_rating.sample : spots.sample
                    cookies[:recommend_spot] = @recommend_spot.id if @recommend_spot
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

    def update_scores_in_cookie(answer) #回答に基づいてスコアを更新
        scores = cookies[:scores] ? JSON.parse(cookies[:scores]) : {} #クッキーからスコアを取得しscoresに格納
        Rails.logger.debug "Initial Scores from Cookie: #{scores.inspect}"

        answer.categories.each do |category| #回答に関連する各カテゴリのスコアを更新
            scores[category.name] = (scores[category.name] || 0) + answer.score
        end
        Rails.logger.debug "Updated Scores: #{scores.inspect}"

        #更新したスコアをクッキーに保存(有効期限は1日)
        cookies[:scores] = { value: JSON.generate(scores), expires: 1.day.from_now }
        Rails.logger.debug "Scores Saved to Cookie: #{cookies[:scores]}"
    end

    def update_answers_in_cookie(answer)
        # クッキーから選択された回答を取得しselected_answersに格納
        selected_answers = cookies[:selected_answers] ? JSON.parse(cookies[:selected_answers]) : []
        Rails.logger.debug "Initial Selected Answers from Cookie: #{selected_answers.inspect}"
    
        # 選択された回答を追加
        selected_answers << answer.answer
        Rails.logger.debug "Updated Selected Answers: #{selected_answers.inspect}"
    
        # 更新した選択された回答をクッキーに保存(有効期限は1日)
        cookies[:selected_answers] = { value: JSON.generate(selected_answers), expires: 1.day.from_now }
        Rails.logger.debug "Selected Answers Saved to Cookie: #{cookies[:selected_answers]}"
    end

    def clear_scores #クッキーを削除
        cookies.delete(:scores)
        cookies.delete(:selected_answers)
        cookies.delete(:recommend_spot)
        Rails.logger.debug "クッキー削除: scores=#{cookies[:scores]}, selected_answers=#{cookies[:selected_answers]}"
    end
end