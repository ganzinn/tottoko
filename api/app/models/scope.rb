class Scope < ActiveHash::Base
  self.data = [
    { id: 1, value: '夫婦のみ', targets: [1, 2] },
    { id: 2, value: '家族みんな', targets: [1, 2, 3, 4, 5, 6, 7, 8] },
    { id: 3, value: '一般公開' }
  ]
end
