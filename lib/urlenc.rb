# frozen_string_literal: true

require 'urlenc/version'

# Usage: urlenc [options]
#     -d, --decode  : Decode/unescape STDIN
#     -e, --encode  : Encode/escape   STDIN
module Urlenc
  require 'erb'
  require 'optparse'

  DESC_DECODE = <<~DECODE
    Decode/unescape STDIN. %22Sample%20Text%21%22 will be
    converted to "Sample Text!"
  DECODE
  DESC_ENCODE = <<~ENCODE
    Encode/escape   STDIN. "Sample Text!" will be converted
    to %22Sample%20Text%21%22
    *default: --encode
  ENCODE
  DESC_SPLIT = <<~SPLIT
    Split before Encode/escape. http://sample Text!/ will
    be converted to http://sample%20Text%21/
    *default: --no-split
  SPLIT
  # Usage: urlenc [options]
  #     -d, --decode  : Decode/unescape STDIN
  #     -e, --encode  : Encode/escape   STDIN
  class Urlenc
    attr_accessor :params

    def initialize
      @params = { encode: true }
    end

    def parse_options
      OptionParser.new do |opts|
        opts = define_options(opts)
        opts.parse!(ARGV, into: @params)
        puts opts.help if @params[:decode].nil? && @params[:encode].nil?
      end
    end

    def run
      if @params[:decode]
        STDIN.each { |line| puts CGI.unescape(line.chomp) }
      elsif @params[:split]
        STDIN.each do |line|
          protocol = line.chomp!.slice!(%r{^.+://}) || ''
          puts protocol + line.split('/', -1).map { |e| ERB::Util.url_encode(e) }.join('/')
        end
      else
        STDIN.each { |line| puts ERB::Util.url_encode(line.chomp) }
      end
    end

    def define_options(opts) # rubocop:disable Metrics/AbcSize
      opts.version = VERSION
      opts.separator ' Required:'
      opts.on('-d', '--decode', *DESC_DECODE.split(/\R/)) { |v| v }
      opts.on('-e', '--encode', *DESC_ENCODE.split(/\R/)) { |v| v }
      opts.separator ''
      opts.separator ' Optional:'
      opts.on('-s', '--[no-]split', *DESC_SPLIT.split(/\R/)) { |v| v }
      opts.separator ''
      opts.separator ' Common options:'
      opts.on_tail('-h', '--help', 'Show this message') do
        puts opts
        exit
      end
      opts.on_tail('-V', '--version', 'Show version') do
        puts opts.ver
        exit
      end
      opts.banner = <<~BANNER

        #{opts.ver}
        #{DESCRIPTION}
        Usage: #{opts.program_name} {decode/encode} [options]
      BANNER
      opts
    end
  end
end
