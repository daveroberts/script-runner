require 'net/sftp'
require 'securerandom'

module SimpleLanguage
  class Sftp
    def self._info
      {
        icon: "fa-folder-open-o",
        summary: "Connect to SFTP server to download files",
        methods: {
          connect: {
            summary: "Establish a connection to an SFTP server",
            params: [
              { name:        "",
                description: "" },
              { name:        "",
                description: "" },
              { name:        "",
                description: "" },
            ],
            returns: {
              name:        "boolean",
              description: "true if connection was successful"
            }
          }
        }
      }
    end

    def initialize
      @sftp = nil
    end

    def connect(hostname, username, password)
      @sftp = Net::SFTP.start(hostname, username, :password => password)
    end

    # Disconnect from an SFTP server
    def disconnect()
      @sftp = nil
    end

    # array of files on the remote path
    def dir(remote_path)
      @sftp.dir.foreach(remote_path)
    end

    # download a file from the remote path
    def download(remote_path)
      file = @sftp.file.open(remote_path)
      content = file.gets
      file.close
      return content
    end

    # uploads a file to an SFTP server. TODO: Not yet implemented
    def upload(remote_path, content)
      return false
    end

    # Move a file on the remote server. TODO: Not yet implemented
    def move(remote_path_from, remote_path_to)
      return false
    end

    # Delete a file on the remote server. TODO: Not yet implemented
    def delete(remote_path)
      return false
    end

  end
end
