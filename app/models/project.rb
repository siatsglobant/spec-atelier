class Project < ApplicationRecord
  belongs_to :user
  default_scope { where(soft_deleted: false) }

  enum project_type: { 'institucional': 'institutional', 'educacional': 'educational', 'hospitalario': 'hospital',
                       'inmobiliario': 'real_state', 'residencial': 'residential', 'comercial': 'commercial',
                       'oficina': 'office' }
  enum work_type: { 'obra nueva': 'new_building', 'ampliación': 'expansion', 'remodelación': 'remodeling' }
  enum status: { active: 1, closed: 0 }
  enum visibility: { public_available: 0, creator_only: 1 }

  scope :search, ->(keywords) { where('name LIKE ?', "%#{keywords}%") }
end
