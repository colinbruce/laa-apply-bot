module Helm
  class List
    def self.call
      releases = JSON.parse(`helm list -o json`, symbolize_names: true)
      values = releases.pluck(:name, :status, :updated)
      result = "#{header}\n#{values.map { |row| parse_row(row) }.join("\n")}"
      "```#{result}```"
    end

    class <<self
      include GithubBits

      private

      def header
        # "#{parse_name('Name')}#{parse_state('Status')}#{'Date'.ljust(11)}#{parse_data('Branch')}#{parse_data('PR')}"
        [
          parse_name('Name'),
          parse_state('Status'),
          'Date'.ljust(11),
          'PR'.ljust(3, ' '),
          parse_data('Branch')
        ].join
      end

      def parse_row(data)
        # "#{parse_name(data[0])}#{parse_state(data[1])}#{parse_date(data[2]).strftime('%Y-%m-%d')}"
        [
          parse_name(data[0]),
          parse_state(data[1]),
          parse_date(data[2]).strftime('%Y-%m-%d').ljust(11),
          (pr_still_exists(data[0]) ? '✔' : '').ljust(3, ' '),
          parse_data((branch_still_exists(data[0]) ? '✔' : ''))
        ].join
      end

      def parse_name(name)
        name.ljust(40, ' ')
      end

      def parse_state(state)
        state.ljust(15, ' ')
      end

      def parse_data(value)
        value.ljust(7, ' ')
      end

      def parse_date(date)
        Date.parse(date)
      end
    end
  end
end
