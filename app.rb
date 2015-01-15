# encoding: utf-8

# 运行前加载所需功能模块包
# gem install sinatra
# gem insatll sinatra-url-for
# gem inatall sinatra-static-assets
# gem install sinatra-flash
# gem install digest-sha2
require 'sinatra'
require 'sinatra/url_for'
#require 'sinatra/static_assets'
#require 'sinatra/flash'
#require 'digest/sha2'



BREADCRUMBS = {
  #1 数据共享--datashare
	datashare: {url: '/datashare', label: '数据共享', map: 'datashare'},
    
    #1.1 疾病--disease
		disease: {url: '/datashare/disease', label: '疾病', map: 'datashare/disease'},
			common: {url: '/datashare/disease/common', label: '常见病', map: 'datashare/disease/common'},
			rare: {url: '/datashare/disease/rare', label: '疑难罕见疾病', map: 'datashare/disease/rare'},
			tumor: {url: '/datashare/disease/tumor', label: '肿瘤', map: 'datashare/disease/tumor'},
			chronic: {url: '/datashare/disease/chronic', label: '慢性病', map: 'datashare/disease/chronic'},
			acuteinfectious: {url: '/datashare/disease/acuteinfectious', label: 'manageother', map: 'datashare/disease/acuteinfectious'},
			diseaseother: {url: '/datashare/disease/diseaseother', label: '其它', map: 'datashare/disease/diseaseother'},
    
    #1.2 医学影像--image
		image: {url: '/datashare/image', label: '医学影像', map: 'datashare/image'},
			xray: {url: '/datashare/image/xray', label: 'X线', map: 'datashare/image/xray'},
			ultrasound: {url: '/datashare/image/ultrasound', label: '超声', map: 'datashare/image/ultrasound'},
			ctscan: {url: '/datashare/image/ctscan', label: 'CT', map: 'datashare/image/ctscan'},
			nmr: {url: '/datashare/image/nmr', label: '核磁共振', map: 'datashare/image/nmr'},
			molecule: {url: '/datashare/image/molecule', label: '分子影像', map: 'datashare/image/molecule'},
			imageother: {url: '/datashare/image/imageother', label: '其它', map: 'datashare/image/imageother'},
    
    #1.3 临床诊断--diagnosis
		diagnosis: {url: '/datashare/diagnosis', label: '临床诊断', map: 'datashare/diagnosis'},
			biochemistry: {url: '/datashare/diagnosis/biochemistry', label: '生化检验', map: 'datashare/diagnosis/biochemistry'},
			auxiliary: {url: '/datashare/diagnosis/auxiliary', label: '辅助检查', map: 'datashare/diagnosis/auxiliary'},
			diagnosisother: {url: '/datashare/diagnosis/diagnosisother', label: '其它', map: 'datashare/diagnosis/diagnosisother'},
    
    #1.4 管理及其他--manage
		manage: {url: '/datashare/manage', label: '管理及其他', map: 'datashare/manage'},
			medicalcare: {url: '/datashare/manage/medicalcare', label: '医疗护理', map: 'datashare/manage/medicalcare'},
			education: {url: '/datashare/manage/education', label: '科研教育', map: 'datashare/manage/education'},
			medicalmanagement: {url: '/datashare/manage/medicalmanagement', label: '医学管理', map: 'datashare/manage/medicalmanagement'},
			manageother: {url: '/datashare/manage/manageother', label: '其它', map: 'datashare/manage/manageother'},

  #2 前沿动态--frontierdynamic
	frontierdynamic: {url: '/frontierdynamic', label: '前沿动态', map: 'frontierdynamic'},
    research: {url: '/frontierdynamic/research', label: '医学研究', map: 'frontierdynamic/research'},
    centralwork: {url: '/frontierdynamic/centralwork', label: '中心工作', map: 'frontierdynamic/centralwork'},
  #3 数据提交--datasubmit
	datasubmit: {url: '/datasubmit', label: '数据提交系统', map: 'datasubmit'},
  
  #4 OA工作平台--oaplatform
	oaplatform: {url: '/oaplatform', label: 'OA工作平台', map: 'oaplatform'},
  
  #5 关于我们--aboutus
	aboutus: {url: '/aboutus', label: '关于我们', map: 'aboutus'},
    platform: {url: '/aboutus/platform', label: '平台简介', map: 'aboutus/platform'},
    central: {url: '/aboutus/central', label: '中心简介', map: 'aboutus/central'},
    webnav: {url: '/aboutus/webnav', label: '网站导航', map: 'aboutus/webnav'},


}

#路径函数
helpers do
  def get_path_map
      path = request.path_info
      BREADCRUMBS.values.reverse.each do |route|
          if path =~ %r(#{route[:url]})
              return route[:map]
          end
      end

      return ''
  end

  def current_path
      path = []
      get_path_map.split('/').each do |part|
          part = part.to_sym
          if BREADCRUMBS.has_key?(part)
              route = BREADCRUMBS[part.to_sym]
              path << [route[:url], route[:label]]
          end
      end
      return path
  end

  def clean_tag(content)
      content.gsub(/\<\/?\w+\>/, '')
  end

end

#首页
get '/' do
  erb :index
end


#数据共享
get '/datashare/?:type?/?:subtype?/?:childtype?' do |type,subtype,childtype|
  if type.nil?
    @path = "/datashare"
    erb :datashare, :layout => :layout
  elsif subtype.nil?
    @path = "/datashare/#{type}"
    erb :"datashare/#{type}.htm", :layout => :two_layout
  elsif childtype.nil?
    @path = "/datashare/#{type}/#{subtype}"
    erb :"datashare/#{type}/#{subtype}.htm", :layout => :two_layout
  else
    @path = "/datashare/#{type}/#{subtype}/#{childtype}"
    erb :"datashare/#{type}/#{subtype}/#{childtype}.htm", :layout => :two_layout
  end
end


#前沿动态
get '/frontierdynamic/?:type?' do |type|
  if type.nil?
    @path = "/frontierdynamic"
    erb :frontierdynamic, :layout => :layout
  else
    @path = "/frontierdynamic/#{type}"
    erb :"aboutus/#{type}.htm", :layout => :two_layout
  end
end


#关于我们
get '/aboutus/?:type?' do |type|
  if type.nil?
    @path = "/aboutus"
    erb :aboutus, :layout => :two_layout
  else
    @path = "/aboutus/#{type}"
    erb :"aboutus/#{type}.htm", :layout => :two_layout
  end
end

#数据提交
get '/datasubmit' do
  erb :datasubmit, :layout => :two_layout
end

#OA工作平台
get '/oaplatform' do
  erb :oaplatform, :layout => :two_layout
end


#找不到页面
not_found do
  erb :"#{env['REQUEST_URI']}.htm", :layout => :two_layout
end