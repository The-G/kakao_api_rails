require 'msgmaker'
require 'parser'

class KakaoController < ApplicationController
  
  @@keyboard = MsgMaker::Keyboard.new
  @@message = MsgMaker::Message.new
  @@parser = Parser::Movie.new
  
  def keyboard
    # keyboard = {
    #   :type => "buttons",
    #   buttons: ["로또","아이디추천", "배달메뉴", "고양이","영화추천"]
    # }
    # render json: keyboard
    
    # Use Module
    
    render json: @@keyboard.getBtnKey(["로또","아이디추천", "배달메뉴", "고양이","영화추천"])

  end

  def message
    user_msg = params[:content]

    if user_msg == "로또"
      msg = (1..46).to_a.sample(6).to_s
    elsif user_msg == "아이디추천"
      msg = Faker::Name.first_name
    elsif user_msg == "배달메뉴"
      msg = ["중식","김밥+돈까스","피자","치킨","족발","편의점","햄버거"].sample
    elsif user_msg == "고양이"
      msg = "고양이를 선택했습니다."
      cat_xml = RestClient.get 'http://thecatapi.com/api/images/get?format=xml&type=jpg'
      doc = Nokogiri::XML(cat_xml)
      cat_url = doc.xpath("//url").text
    elsif user_msg == "영화추천"
      # require "nokogiri"
      # require "open-uri"
      # doc = Nokogiri::HTML(open("http://movie.naver.com/movie/running/current.nhn"))
      # movie_title = Array.new
      # p "ttt"
      # doc.css("ul.lst_detail_t1 dt a").each do |title|
      #   p "title0"
      #   movie_title << title.text
      #   p title.text
      # end
      # msg = movie_title.sample.to_s
      msg = @@parser.naver
    else
      msg = "잘못선택했습니다."
    end
    
    # message = {
    #   text: msg
    # }
    message = @@message.getMessage(msg)
    # message_photo = {
    #   text: "나만고양이없어",
    #   photo: {
    #     url: cat_url,
    #     width: 640,
    #     height: 480
    #   }
    # }
    message_photo = @@message.getPicMessage("나만고양이없어",cat_url)
    
    # 자주 사용할 키보드를 만들어 주겠습니다.
    # basic_keyboard = {
    #   :type => "buttons",						
    #   buttons: ["로또","아이디추천", "배달메뉴", "고양이","영화추천"]
    # }
    # Use Module
    
    basic_keyboard = @@keyboard.getBtnKey(["로또","아이디추천", "배달메뉴", "고양이","영화추천"])

    
    # 응답
    if user_msg == "고양이"
      result = {
        message: message_photo,
        keyboard: basic_keyboard
      }
    else
      result = {
        message: message,
        keyboard: basic_keyboard
      }
    end
    
    render json: result
  end
  
  def friend_add
    user_key = params[:user_key]
    
    # 새로운 유저를 저장
    User.create(
      user_key: user_key,
      visited: 0
      )
      
    render nothing: true
  end
  
  def friend_del
    user_key = params[:user_key]
    # 유저를 삭제
    User.find_by(user_key: user_key).destroy
  
    render nothing: true
  end
  
  def chat_room
    user_key = params[:user_key]
    # increase visited count
    user = User.find_by(user_key: user_key)
    user.visited += 1
    user.save
    
    render nothing: true
  end

  
end
