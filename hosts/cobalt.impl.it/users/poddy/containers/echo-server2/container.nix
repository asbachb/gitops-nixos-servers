{
  echo-server2 = {
    autoStart = true;
    serviceConfig = {
      RestartSec = "10";
      Restart = "always";
    };
    containerConfig = {
      image = "docker.io/mendhak/http-https-echo:31";
      publishPorts = [ "127.0.0.1:8090:8090" ];
      userns = "keep-id";
    };
  };
}