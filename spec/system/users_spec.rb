require 'rails_helper'

RSpec.feature 'Password', type: :system do
  background do
    # 事前
  end

  scenario 'ログインしてパスワードを変更する' do
    # 第2章 Enjuを利用する - Next-L Enju初期設定マニュアル
    visit 'http://localhost:8080'

    # ログインされていないこと
    expect(page).to have_content 'えんじゅ図書館'
    expect(page).to have_content 'ログイン'
    expect(page).to have_content 'Next-L Enju Leaf 1.3.0'

    # ログインクリック
    click_on 'ログイン'

    # ログイン画面になっていること
    expect(page).to have_content 'ログイン : Next-L Enju'
    expect(page).to have_field 'user[username]'
    expect(page).to have_field 'user[password]'

    # ID/passwordをログイン
    fill_in 'user[username]', with: 'enjuadmin'
    fill_in 'user[password]', with: 'adminpassword'
    click_on 'ログイン'

    # 正しく更新されていること（＝画面の表示が正しいこと）を検証する
    expect(page).to have_content 'ログインしました。'
    expect(page).to have_content 'enjuadmin としてログイン'
    expect(page).to have_content 'ようこそ enjuadmin さん'
    expect(page).to have_content 'アカウント'
    expect(page).to have_content 'ログアウト'

    # アカウントクリック
    click_on 'アカウント'
    expect(page).to have_content '利用者アカウントの表示'
    expect(page).to have_content '[U] enjuadmin'
    expect(page).to have_content '利用者番号: 0'
    expect(page).to have_content '編集'
    expect(page).to have_content 'パスワード変更'
    expect(page).to have_content '貸出の一覧'
    expect(page).to have_content '予約の一覧'

    # パスワードクリック
    click_on 'パスワード変更'

    page.save_screenshot 'screenshot.png'

    expect(page).to have_content '現在のパスワード (we need your current password to confirm your changes)'
    expect(page).to have_content "パスワード (leave blank if you don't want to change it)"
    expect(page).to have_content 'パスワード（確認）'

    fill_in 'user[current_password]', with: 'adminpassword'
    fill_in 'user[password]', with: 'adminpassword2'
    fill_in 'user[password_confirmation]', with: 'adminpassword2'
    click_on '更新'

    expect(page).to have_content 'アカウントは正常に更新されました。'

    click_on 'ログアウト'
    expect(page).to have_content 'ログアウトしました。'

    click_on 'ログイン'

    # ID/passwordをログイン
    fill_in 'user[username]', with: 'enjuadmin'
    fill_in 'user[password]', with: 'adminpassword2'
    click_on 'ログイン'

    expect(page).to have_content 'ログインしました。'

    click_on 'アカウント'
    click_on 'パスワード変更'
    fill_in 'user[current_password]', with: 'adminpassword2'
    fill_in 'user[password]', with: 'adminpassword'
    fill_in 'user[password_confirmation]', with: 'adminpassword'
    click_on '更新'

  end
end