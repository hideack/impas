class Recommender < Recommendify::Base
  max_neighbors 50

  input_matrix :visits,
    :similarity_func => :jaccard,
    :native => true,
    :weight => 5.0

end

