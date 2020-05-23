#!/usr/bin/ruby
# frozen_string_literal: true

# Scalelite recording transfer script

require 'optparse'
require 'psych'
require 'fileutils'

meeting_id = nil
OptionParser.new do |opts|
  opts.on('-m', '--meeting-id MEETING_ID', 'Internal Meeting ID') do |v|
    meeting_id = v
  end
end.parse!
raise 'Meeting ID was not provided' unless meeting_id

props = Psych.load_file(File.join(__dir__, '../bigbluebutton.yml'))
published_dir = props['published_dir'] || raise('Unable to determine published_dir from bigbluebutton.yml')
owncloud_props = Psych.load_file(File.join(__dir__, '../owncloud.yml'))
work_dir = owncloud_props['work_dir'] || raise('Unable to determine work_dir from owncloud.yml')
user = owncloud_props['user'] || raise('Unable to determine user from owncloud.yml')
pwd = owncloud_props['pwd'] || raise('Unable to determine pwd from owncloud.yml')
server_URL = owncloud_props['URL'] || raise('Unable to determine pwd from owncloud.yml')
spool_dir = owncloud_props['spool_dir'] || raise('Unable to determine spool_dir from owncloud.yml')


puts("Transferring recording for #{meeting_id} to OwnCloud")
format_dirs = []
FileUtils.cd(published_dir) do
  format_dirs = Dir.glob("*/#{meeting_id}")
end
if format_dirs.empty?
  puts('No published recording formats found')
  exit
end

format_dirs.each do |format_dir|
  puts("Found recording format: #{format_dir}")
end

archive_file = "#{work_dir}/#{meeting_id}.tar"
begin
  puts('Creating recording archive')
  FileUtils.mkdir_p(work_dir)
  FileUtils.cd(published_dir) do
    system('tar', '--create', '--file', archive_file, *format_dirs) \
      || raise('Failed to create recording archive')
  end

  puts("Transferring recording archive to #{spool_dir}")
  system('rsync', '--verbose', '--protect-args', archive_file, spool_dir) \
    || raise('Failed to transfer recording archive')

  puts("Sync with OwnCloud")
  system('owncloudcmd', '--user', user, '--password', pwd, spool_dir, server_URL) \
    || raise('Failed to sync with OwnCloud')
ensure
  FileUtils.rm_f(archive_file)
end

