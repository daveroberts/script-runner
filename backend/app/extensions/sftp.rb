require 'net/sftp'
require 'securerandom'

class Sftp
  def self.icon
    "fa-folder-open-o"
  end

  def initialize
    @sftp = nil
  end

  # Establish a connection to an SFTP server
  def sftp_connect(hostname, username, password)
    @sftp = Net::SFTP.start(hostname, username, :password => password)
  end

  # Disconnect from an SFTP server
  def sftp_disconnect()
    @sftp = nil
  end

  # array of files on the remote path
  def sftp_dir(remote_path)
    @sftp.dir.foreach(remote_path)
  end

  # download a file from the remote path
  def sftp_download(remote_path)
    file = @sftp.file.open(remote_path)
    content = file.gets
    file.close
    return content
  end

  # uploads a file to an SFTP server. TODO: Not yet implemented
  def sftp_upload(remote_path, content)
    return false
  end

  # Move a file on the remote server. TODO: Not yet implemented
  def sftp_move(remote_path_from, remote_path_to)
    return false
  end

  # Delete a file on the remote server. TODO: Not yet implemented
  def sftp_delete(remote_path)
    return false
  end

end
