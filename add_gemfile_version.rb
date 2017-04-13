def replace_gem_version(gem_name, gem_version)
  gemfile_text = File.read 'Gemfile'
  if gemfile_text =~ /gem\s+[\'\"]#{gem_name}[\'\"]\,(\s?|\s+)[\'\"]/
    #gem 'gem_name', '0.0.0.'
    new_text = gemfile_text.gsub(/gem\s+[\'\"]#{gem_name}[\'\"],(\s?|\s+)[\'\"][^\'\"]+[\'\"]/, "gem '#{gem_name}', '#{gem_version}'")
  elsif gemfile_text =~ /gem\s+[\'\"]#{gem_name}[\'\"],(\s?|\s+)(:?group|:?require|:?engine|:?engine_version)+/ || gemfile_text =~ /gem\s+[\'\"]#{gem_name}[\'\"](\n|$)/
    #gem 'gem_name', require: false  (:require =>)
    #gem 'gem_name', group: :test (:group => :test)
    #gem 'gem_name'
    new_text = gemfile_text.gsub(/gem\s+[\'\"]#{gem_name}[\'\"]/, "gem '#{gem_name}', '#{gem_version}'")
  else
    # Desabilitado, pois podem ser gems dependencias
    # puts "Nao encontrado, adicione manualmente: gem #{gem_name}, '#{gem_version}'"
  end
  if new_text
    # puts new_text
    File.open('Gemfile', "w") {|file| file.puts new_text }
  end
end

gem_list = `bundle list`
gem_list = gem_list.split("\n")
gem_list.each do |gem|
  gem_name, gem_version = gem.strip.scan(/\*\s+([^\(]+)\s+\(([^\)\s]+)\)?/).first
  unless gem_name.nil?
    replace_gem_version gem_name, gem_version
  end
end
