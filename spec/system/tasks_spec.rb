require 'rails_helper'

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    before do
      # ユーザーAを作成しておく
      # user_a = FactoryBot.create(:user)
      user_a = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')
      # 作成者がユーザーAであるタスクを作成しておく
      FactoryBot.create(:task, name: '最初のタスク', user: user_a)
    end

    context 'ユーザーAがログインしているとき' do
      before do
        # ユーザーAでログインする
        # つまり、session#createが実行される
        # HTTPリクエストを投げるようにするべきか？
        #
        # 1. ログイン画面にアクセスする
        visit login_path

        # 2. メールアドレスを入力する
        fill_in 'メールアドレス', with: 'a@example.com'

        # 3. 送信ボタンを押す
        fill_in 'パスワード', with: 'password'

        # 4. 「ログインする」ボタンを押す
        click_button 'ログインする'
      end

      it 'ユーザーAが作成したタスクが表示される' do
        # 作成済のタスクの名称が画面上に表示されていることを確認
        expect(page).to have_content '最初のタスク'
      end
    end
  end
end
