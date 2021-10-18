# https://github.com/bnix/double-bag-ftps/issues/17
# implicit に対応するためのパッチ

require 'net/ftp'

module Bizside
  class ImplicitFTPS < Net::FTP
    FTP_PORT = 990

    def connect(host, port = FTP_PORT)
      synchronize do
        @host = host
        @bare_sock = open_socket(host, port)
        begin
          ssl_sock = start_tls_session(Socket.tcp(host, port))
          @sock = BufferedSSLSocket.new(ssl_sock, read_timeout: @read_timeout)
          voidresp
          if @private_data_connection
            voidcmd("PBSZ 0")
            voidcmd("PROT P")
          end
        rescue OpenSSL::SSL::SSLError, Net::OpenTimeout
          @sock.close
          raise
        end
      end
    end
  end
end
