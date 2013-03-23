class Recommender < Recommendify::Base
  input_matrix :visits,
    :similarity_func => :jaccard,
    :native => true
end

