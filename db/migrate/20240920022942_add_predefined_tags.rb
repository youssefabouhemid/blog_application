class AddPredefinedTags < ActiveRecord::Migration[7.2]
  def change
    Tag.create([
                 { value: "Test" },
                 { value: 'Technology' },
                 { value: 'Programming' },
                 { value: 'Ruby on Rails' },
                 { value: 'Web Development' },
                 { value: 'Startup' },
                 { value: 'Artificial Intelligence' },
                 { value: 'Data Science' },
                 { value: 'Travel' },
                 { value: 'Food' },
                 { value: 'Health' },
                 { value: 'Fitness' },
                 { value: 'Lifestyle' },
                 { value: 'Productivity' },
                 { value: 'Marketing' },
                 { value: 'Finance' },
                 { value: 'Investing' },
                 { value: 'Cryptocurrency' },
                 { value: 'Design' },
                 { value: 'Photography' },
                 { value: 'Mental Health' },
                 { value: 'Parenting' },
                 { value: 'Education' },
                 { value: 'Science' },
                 { value: 'Innovation' },
                 { value: 'UX/UI' },
                 { value: 'Machine Learning' },
                 { value: 'Self-Improvement' },
                 { value: 'Social Media' },
                 { value: 'Environment' },
                 { value: 'Gaming' }
               ])
  end
end
