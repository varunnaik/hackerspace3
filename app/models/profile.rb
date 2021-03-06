class Profile < ApplicationRecord
  belongs_to :user

  acts_as_taggable_on :skills

  enum first_peoples: {
    'No' => 0,
    'Yes, Aboriginal' => 1,
    'Yes, Torres Strait Islander' => 2,
    'Prefer not to say' => 3
  }

  enum disability: {
    'Yes' => 0,
    'No' => 1,
    'Prefer not to say' => 2
  }, _suffix: true

  enum education: {
    'Less that Year 12 or equivalent' => 0,
    'Year 12 or equivalent' => 1,
    'Vocational Qualification' => 2,
    'Associate diploma' => 3,
    'Undergraduate diploma' => 4,
    'Bachelor degree (including honours)' => 5,
    'Postgraduate diploma (includes graduate certificate)' => 6,
    "Master's degree" => 7,
    'Doctorate' => 8,
    'Prefer not to say' => 9
  }, _prefix: true

  enum employment: {
    'Employed, working full time' => 0,
    'Employed, working part time or casual' => 1,
    'Student, studying full time' => 2,
    'Student, studying part time' => 3,
    'Not employed, looking for work' => 4,
    'Not employed, NOT looking for work' => 5,
    'Retired' => 6,
    'Disabled, not able to work' => 7,
    'Prefer not to say' => 8
  }, _prefix: true

  enum age: {
    'Under 18' => 0,
    '18-24 years old' => 1,
    '25-34 years old' => 2,
    '35-44 years old' => 3,
    '45-54 years old' => 4,
    '55-64 years old' => 5,
    '64-75 years old' => 6,
    '75 years and older' => 7,
    'Prefer not to say' => 8
  }, _prefix: true
end
