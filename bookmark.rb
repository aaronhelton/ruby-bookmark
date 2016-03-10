#!/usr/bin/env ruby

#####
# Ruby bookmark utility.
#####

class Bookmark
  attr_reader :id, :comments, :excerpts, :destination

  def initialize(id)
    @id = id
    @comments = Array.new
    @excerpts = Array.new
    @destination = nil
  end

  def to_html
    html_array = Array.new
    @comments.each do |comment|
      html_array << "<p>#{comment}</p>"
    end
    if @excerpts.size > 0
      html_array << "<blockquote><p>#{@excerpts.join("</p>\n<p>[...]</p>\n<p>")}</p></blockquote>"
    end
    return html_array.join("\n")
  end
end

class Destination
  attr_reader :handler

  def initialize(handler)
    # handler is supposed to be a location in the plugins directory
    if File.exists?('plugins/' + handler)
      @handler = handler
    else
      abort "Handler doesn't exist."
    end
  end
end

class Excerpt
  attr_reader :display_order, :text

  def initialize(display_order, text)
    @display_order = display_order
    @text = text
  end
end

class Comment
  attr_reader :display_order, :text

  def initialize(display_order, text)
    @display_order = display_order
    @text = text
  end
end

## register known handlers
known_handlers = Array.new
Dir.foreach('plugins') do |file|
  unless file == '.' || file == '..'
    known_handlers << file.split('.')[0]
  end
end

## list of available console commands

$commands = [
  {'code' => 'f', 'function' => 'do_foo', 'help_text' => '(f)oo'},
  {'code' => 'a', 'function' => 'add_comment_or_excerpt', 'help_text' => '(a)dd comment or excerpt'},
  {'code' => 'd', 'function' => 'delete_comment_or_excerpt', 'help_text' => '(d)elete comment or excerpt'},
  {'code' => 'q', 'function' => 'quit', 'help_text' => '(q)uit'}
]

def do_foo
  puts "you got me"
  print ">> "
end

def quit
  abort
end

def print_help_text
  print "Available commands are: "
  help_text_array = Array.new
  $commands.each do |command|
    help_text_array << command['help_text']
  end
  puts help_text_array.join(", ")
end

puts "Known plugins: #{known_handlers.join(',')}"
print_help_text
print ">> "

loop do
  command = STDIN.gets.chomp

  command_idx = $commands.find_index {|c| c['code'] == command}
  if command_idx
    send($commands[command_idx]['function'])
  else
    puts "Invalid command"
    print_help_text
  end
end
