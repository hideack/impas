# -*- encoding: utf-8 -*-
require 'faraday'

desc 'レコメンド実行'
task :recommend do
  Group.select(:id).each do |group|
    Visitlog.select(:visitor).uniq.where(:group_id => group.id).each do |visitor|
      recommend_process(group.id, visitor.visitor)
    end
  end

end

def recommend_process(gid, visitor_id)
  pages = Visitlog.select([:url_id, :normalize_count]).uniq.where(:group_id => gid, :visitor => visitor_id)
  recommend_pages = {}

  pages.each do |page|
    comparsion_visitors = Visitlog.select(:visitor).uniq.where(:group_id => gid, :url_id => page.url_id)
    
    # レコメンド対象ユーザが閲覧したページをイテレート
    comparsion_visitors.each do |comparsion_visitor|
      next if visitor_id == comparsion_visitor.visitor
      
      # 該当ページを閲覧した他ユーザとレコメンド対象ユーザの類似度算出
      sim = Impas.cache.get("similarity:#{visitor_id}:#{comparsion_visitor.visitor}")
      sim = similiarity(gid, visitor_id, comparsion_visitor.visitor) if sim.nil?

      logger.info "Similarity(#{visitor_id} vs #{comparsion_visitor.visitor}) = #{sim}"

      # 他ユーザが見ているページからレコメンド候補を抽出
      visitings = Visitlog.select([:url_id, :normalize_count]).where(:group_id => gid, :visitor => comparsion_visitor.visitor)
      visitings.each do |one_recommend|
        ratio = one_recommend.normalize_count * sim * page.normalize_count

        recommend_pages[one_recommend.url_id] = 0.0 if recommend_pages[one_recommend.url_id].nil?
        recommend_pages[one_recommend.url_id] = recommend_pages[one_recommend.url_id] + ratio
      end
    end
  end

  # レコメンド確定・記録
  Recommend.where(:group_id=> gid, :visitor => visitor_id).destroy_all

  recommend_pages.each do |url_id, ratio|
    next if Visitlog.where(:group_id => gid, :visitor => visitor_id, :url_id => url_id).count > 0 # 過去閲覧ページは除外

    rec = Recommend.find(:first, :conditions => {:group_id => gid, :visitor => visitor_id, :url_id => url_id})
    rec = Recommend.new if rec.nil?

    rec.group_id = gid
    rec.visitor = visitor_id
    rec.url_id = url_id
    rec.recommended_ratio = ratio
    rec.save!
  end
end


# ユーザ間類似度算出
def similiarity(group_id, visitor_id, comparsion_visitor_id)
  logger.info "Similarity calculation - #{visitor_id} vs #{comparsion_visitor_id} | group id = #{group_id}"

  visitor_vector_abs    = Visitlog.sum(:normalize_abs, :conditions => {:group_id => group_id, :visitor => visitor_id})
  comparsion_vector_abs = Visitlog.sum(:normalize_abs, :conditions => {:group_id => group_id, :visitor => comparsion_visitor_id})

  return 0.0 if visitor_vector_abs.nil? || comparsion_vector_abs.nil?

  visitor_pages = Visitlog.select([:url_id, :normalize_count]).uniq.where(:group_id => group_id, :visitor => visitor_id)

  mat = 0.0
  visitor_pages.each do |page|
    comparsion_page = Visitlog.find(:first, :conditions => {:group_id => group_id, :visitor => comparsion_visitor_id, :url_id => page.url_id})
    next if comparsion_page.nil?

    mat = mat + (page.normalize_count * comparsion_page.normalize_count)
  end

  sim = (mat / visitor_vector_abs * comparsion_vector_abs)
  Impas.cache.set("similarity:#{visitor_id}:#{comparsion_visitor_id}", sim, :expires_in => 3600)

  # Similarity
  sim
end



