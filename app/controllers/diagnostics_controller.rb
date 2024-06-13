class DiagnosticsController < ApplicationController
    before_action :set_question, only: [:show_question, :answer_question]

    def start
        clear_scores #スコアをクリア
        @question = DiagnosticQuestion.first #最初の質問を@questionにセット
        session[:diagnostic] = { scores: {} } #セッションに診断のスコアを格納するためのハッシュを初期化
    end

    def show_question ;end #idを使って対象の質問を取得し@questionにセット
    
    def answer_question 
        #params[:answer_id]で選択された回答を取得しselected_answerにセット
        selected_answer = @question.diagnostic_answers.find(params[:answer_id])
        
        # クッキーでスコアを保存するためにupdate_scores_in_cookieを呼び出す
        update_scores_in_cookie(selected_answer)
        
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

        @top_category = scores.max_by { |_, score| score }&.first #最もスコアの高いカテゴリを取得
        
        if @top_category.nil? #@top_categoryがnilの場合、エラーメッセージを表示診断開始画面にリダイレクト
            flash[:error] = "診断結果が見つかりませんでした。診断を最初からやり直してください。"
            redirect_to start_diagnostics_path
        else #結果ページをレンダリング
            render 'result'
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

    def clear_scores #クッキーを削除
        cookies.delete(:scores)
    end
end