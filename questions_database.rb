require 'sqlite3'
require 'singleton'


class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end

end 

class Users
    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        data.map { |datum| Users.new(datum) }
    end


    def self.find_by_id(id)
        identification = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          users
        WHERE
          id = ?
      SQL
      return nil unless identification.length > 0
  
      Users.new(identification.first)
    end
    def self.find_by_name(fname,lname)
        name = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        SELECT
        *
        FROM
        users
        WHERE
        fname = ? AND lname = ?
        SQL
        return nil unless name.length > 0
  
        Users.new(name.first)

    end

    def self.find_by_fname(fname)


        firstname = QuestionsDatabase.instance.execute(<<-SQL, fname)
        SELECT
          *
        FROM
          users
        WHERE
          fname = ?
      SQL
      return nil unless firstname.length > 0
  
      Users.new(firstname.first)
    end

    def self.find_by_lname(lname)
        
        lastname = QuestionsDatabase.instance.execute(<<-SQL, lname)
        SELECT
          *
        FROM
          users
        WHERE
          lname = ?
      SQL
      return nil unless lastname.length > 0
  
      Users.new(lastname.first)
    end

    def authored_questions
        Questions.find_by_author_id(self.id)

    end

    def authored_replies
        Replies.find_by_user_id(self.id)

    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end
    attr_accessor :fname, :id, :lname 

end

class Questions
    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        data.map { |datum| Questions.new(datum) }
    end


    def self.find_by_id(id)
        identification = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          questions
        WHERE
          id = ?
      SQL
      return nil unless identification.length > 0
  
      Questions.new(identification.first)
    end


    def self.find_by_title(title)

        title = QuestionsDatabase.instance.execute(<<-SQL, title)
        SELECT
          *
        FROM
          questions
        WHERE
          title = ?
      SQL
      return nil unless title.length > 0
  
      Questions.new(title.first)
    end

    def self.find_by_body(body)
        body = QuestionsDatabase.instance.execute(<<-SQL, body)
        SELECT
          *
        FROM
          questions
        WHERE
          body = ?
      SQL
      return nil unless body.length > 0
  
      Questions.new(body.first)
    end

    def self.find_by_author_id(author_id)

        questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
        SELECT
          *
        FROM
          questions
        WHERE
          author_id = ?
      SQL
        questions.map {|question| Questions.new(question)}
    end

    def author
        # temp = Questions.find_by_id(self.id)
        # Users.find_by_id(temp)
        data = QuestionsDatabase.instance.execute(<<-SQL, @author_id)
        SELECT
            *
        FROM
            users
        WHERE
            users.id = ?
        SQL
        Users.new(data[0])
    end

        


    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end
    attr_accessor :id, :title, :body, :author_id

end

class QuestionFollows
    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
        data.map { |datum| QuestionFollows.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

    def self.find_by_id(id)
        identification = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          question_follows
        WHERE
          id = ?
      SQL
  
      QuestionFollows.new(identification.first)
    end

    def self.find_by_question_id(question_id)

        question_id = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
          *
        FROM
          question_follows
        WHERE
          question_id = ?
        SQL
        question_id.map {|question| QuestionFollows.new(question)}
    end

    def self.find_by_user_id(user_id)

        user_id = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT
          *
        FROM
          question_follows
        WHERE
          user_id = ?
        SQL
        user_id.map {|user| QuestionFollows.new(user)}
    end



    attr_accessor :id, :question_id, :user_id
end    

class Replies

        def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        data.map { |datum| Replies.new(datum) }
    end

    def self.find_by_id(id)
        identification = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          replies
        WHERE
          id = ?
      SQL
  
      Replies.new(identification.first)
    end

    def self.find_by_parent_question(parent_id)
        parent_id = QuestionsDatabase.instance.execute(<<-SQL, parent_id)
        SELECT
          *
        FROM
          replies
        WHERE
          parent_question = ?
      SQL
  
      Replies.new(parent_id.first)
    end

    def self.find_by_parent_reply_id(parent_reply_id)
        parent_reply_id = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
        SELECT
          *
        FROM
          replies
        WHERE
          parent_reply_id = ?
      SQL
      return nil unless parent_reply_id.length > 0
      Replies.new(parent_reply_id.first)
    end

    def self.find_by_user_id(user_id)

        user_id = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT
          *
        FROM
          replies
        WHERE
          user_id = ?
        SQL
        user_id.map {|user| Replies.new(user)}
    end

    def self.find_by_question_body(question_body)
        question_body = QuestionsDatabase.instance.execute(<<-SQL, question_body)
        SELECT
          *
        FROM
          replies
        WHERE
          question_body = ?
      SQL
  
      Replies.new(question_body.first)
    end


    def initialize(options)
        @id = options['id']
        @parent_question = options['parent_question']
        @parent_reply_id = options['parent_reply_id']
        @user_id = options['user_id']
        @question_body = options['question_body']

    end

    attr_accessor :id, :parent_question,:parent_reply_id, :user_id, :question_body

end

class QuestionLikes
    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
        data.map { |datum| QuestionLikes.new(datum) }
    end

    def self.find_by_id(id)
        identification = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          question_likes
        WHERE
          id = ?
      SQL
  
      QuestionLikes.new(identification.first)
    end

    def self.find_by_question_id(question_id)

        question_id = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
          *
        FROM
          question_likes
        WHERE
          question_id = ?
        SQL
        question_id.map {|question| QuestionLikes.new(question)}
    end

    def self.find_by_user_id(user_id)

        user_id = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT
          *
        FROM
          question_likes
        WHERE
          user_id = ?
        SQL
        user_id.map {|user| QuestionLikes.new(user)}
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

    attr_accessor :id, :question_id, :user_id
end  


# Question::find_by_author_id(author_id)
# Reply::find_by_user_id(user_id)
# Reply::find_by_question_id(question_id)
# User::find_by_name(fname, lname)
# User#authored_questions (use Question::find_by_author_id)
# User#authored_replies (use Reply::find_by_user_id)
# Question#author
# Question#replies (use Reply::find_by_question_id)
# Reply#author
# Reply#question
# Reply#parent_reply
# Reply#child_replies
# QuestionFollow::followers_for_question_id(question_id)
# This will return an array of User objects.
# QuestionFollow::followed_questions_for_user_id(user_id)
# Returns an array of Question objects.
# User#followed_questions
# One-liner calling QuestionFollow method.
# Question#followers
# One-liner calling QuestionFollow method.