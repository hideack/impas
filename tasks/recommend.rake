# -*- encoding: utf-8 -*-
require 'faraday'

desc 'レコメンド実行'
task :recommend do 
  processor_count = (Parallel.processor_count > 1) ? (Parallel.processor_count - 1) : 1

  puts "Recommendation start. - #{Time.now.to_s}"
  puts "CPU count : #{processor_count}"
  puts "Command   : #{ENV['option']}"

  Group.select(:id).each do |group|
    visitors = Visitlog.select(:visitor).uniq.where(:group_id => group.id)
    Parallel.each(visitors, in_threads: processor_count) do |visitor|
      case ENV['option']
      when 'recommend'
        recommend_process(group.id, visitor.visitor)
      when 'user_similarity'
        user_similarity_process(group.id, visitor.visitor)
      end
    end
  end

  puts "Recommendation finished. - #{Time.now.to_s}"
end

def recommend_process(gid, visitor_id)
  recommend_pages = {}

  Visitlog.select([:url_id, :normalize_count]).uniq.where(:group_id => gid, :visitor => visitor_id).find_each do |page|
    # レコメンド対象ユーザが閲覧したページをイテレート
    Visitlog.select(:visitor).uniq.where(:group_id => gid, :url_id => page.url_id).find_each do |comparsion_visitor|
      next if visitor_id == comparsion_visitor.visitor
      
      # 該当ページを閲覧した他ユーザとレコメンド対象ユーザの類似度算出
      similarity = Similarity.find(:first, :conditions => {:group_id => gid, :visitor => visitor_id, :target_visitor => comparsion_visitor.visitor})
      next if similarity.nil?

      sim = similarity.similar_ratio

      logger.info "Similarity(#{visitor_id} vs #{comparsion_visitor.visitor}) = #{sim}"
      next if sim < USER_SIMILARITY_RATIO_MINIMUM

      # 他ユーザが見ているページからレコメンド候補を抽出
      weight = sim * page.normalize_count

      urls = Visitlog.where(:group_id => gid, :visitor => comparsion_visitor.visitor).pluck(:url_id)
      normalize_counts = NArray.to_na(Visitlog.where(:group_id => gid, :visitor => comparsion_visitor.visitor).pluck(:normalize_count))
      recommend_ratios = normalize_counts * weight

      urls.each_with_index do |url, count|
        recommend_pages[url] = 0.0 if recommend_pages[url].nil?
        recommend_pages[url] = recommend_pages[url] + recommend_ratios[count]
      end

    end
  end

  # レコメンド確定・記録
  Recommend.where(:group_id=> gid, :visitor => visitor_id).destroy_all

  recommend_pages.each do |url_id, ratio|
    next if Visitlog.where(:group_id => gid, :visitor => visitor_id, :url_id => url_id).count > 0 # 過去閲覧ページは除外
    next if ratio < RECOMMEND_RATIO_MINIMUM

    rec = Recommend.find(:first, :conditions => {:group_id => gid, :visitor => visitor_id, :url_id => url_id})
    rec = Recommend.new if rec.nil?

    rec.group_id = gid
    rec.visitor = visitor_id
    rec.url_id = url_id
    rec.recommended_ratio = ratio
    rec.save!
  end
end

def user_similarity_process(gid, visitor_id)
  logger.info "Group:#{gid} / visitor:#{visitor_id}"

  visitPages = Visitlog.select(:url_id).uniq.where(:group_id => gid, :visitor => visitor_id)

  visitPages.each do |page|
    # レコメンド対象ユーザが閲覧したページをイテレート
    Visitlog.select(:visitor).uniq.where(:group_id => gid, :url_id => page.url_id).find_each do |comparsion_visitor|
      next if visitor_id == comparsion_visitor.visitor
      ratio = similiarity(gid, visitor_id, comparsion_visitor.visitor)

      similar = Similarity.find(:first, :conditions => {:group_id => gid, :visitor => visitor_id, :target_visitor => comparsion_visitor.visitor})
      similar = Similarity.new if similar.nil?

      similar.group_id = gid
      similar.visitor = visitor_id
      similar.target_visitor = comparsion_visitor.visitor
      similar.similar_ratio = ratio
      similar.save!
    end
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

  sim = mat / (Math.sqrt(visitor_vector_abs) * Math.sqrt(comparsion_vector_abs))

  # Similarity
  sim
end



