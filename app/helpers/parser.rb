require 'nokogiri'
require 'open-uri'
require 'rest-client'

module Parser
    class Movie
        def naver
            # 네이버 현재상영영화중 하나를 랜덤으로 뽑아주는 코드
        
            doc = Nokogiri::HTML(open("http://movie.naver.com/movie/running/current.nhn"))
            movie_title = Array.new
            # movie_imgUrl = Array.new
            
            doc.css("ul.lst_detail_t1 dt a").each do |title|
            	movie_title << title.text
            end
            # doc.css("ul.lst_detail_t1 div.thumbt a img").each do |img|
            # 	movie_imgUrl << title.src
            # end
            
            title = movie_title.sample
            # imgUrl = movie_imgUrl.sample
            return "<" + title + ">"
            # return imgUrl
        end
    end
    
    class Animal
        def cat
            cat_xml = RestClient.get 'http://thecatapi.com/api/images/get?format=xml&type=jpg'
            doc = Nokogiri::XML(cat_xml)
            cat_url = doc.xpath("//url").text
            
            return cat_url
        end
    end
end