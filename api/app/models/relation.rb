class Relation < ActiveHash::Base
  self.data = [
    { id: 0, value: '---' },
    { id: 1, value: 'パパ' },
    { id: 2, value: 'ママ' },
    { id: 3, value: 'おじいちゃん' },
    { id: 4, value: 'おばあちゃん' },
    { id: 5, value: 'おじさん' },
    { id: 6, value: 'おばさん' },
    { id: 7, value: '子ども自身' },
    { id: 8, value: '親族ほか' }
  ]
end
