require 'middleman-core'
require 'middleman-blog'

module Middleman::Blog
  module Similar
    class Groonga < ::Middleman::Extension
      option :db_path, 'groonga/articles', 'Path to Groonga database'

      def initialize(app, options_hash={}, &block)
        super

        app.config[:blog_similar_groonga] = self

        @db_path = Pathname.new(options.db_path)
        require 'groonga'
      end

      def after_configuration
        if @db_path.file?
          ::Groonga::Database.open @db_path.to_path
        else
          @db_path.dirname.mkpath unless @db_path.dirname.directory?
          ::Groonga::Database.create(path: @db_path.to_path)
          ::Groonga::Schema.create_table 'Articles', type: :hash do |table|
            table.short_text 'title'
            table.long_text 'body'
            # TODO: tags
          end
          ::Groonga::Schema.create_table 'Terms', type: :patricia_trie, normalizer: :NormalizerAuto, default_tokenizer: 'TokenMecab'
          ::Groonga::Schema.change_table 'Terms' do |table|
            table.index 'Articles.body'
          end
        end

        articles = ::Groonga['Articles']
        app.sitemap.resources.each do |resource|
          next unless resource.kind_of? ::Middleman::Blog::BlogArticle

          key = resource.path
          articles.add key unless articles[key]

          articles[key].title = resource.title
          articles[key].body = Nokogiri.HTML('<body>' + resource.body + '</body>').search('body').first.content
        end
      end

      helpers do
        def similar_articles
          current_body = Nokogiri.HTML('<body>' + current_page.body + '</body>').search('body').first.content
          results = ::Groonga['Articles'].select {|article|
            article.body.similar_search(current_page.summary) &
              (article.key != current_page.path)
          }
          results.sort([key: '_score', order: 'descending'])
          results
        end
      end
    end
  end
end

::Middleman::Extensions.register :blog_similar_groonga, ::Middleman::Blog::Similar::Groonga
