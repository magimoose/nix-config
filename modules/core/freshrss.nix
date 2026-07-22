{ ... }:
{
  services.freshrss = {
    enable = true;
    baseUrl = "http://localhost";
    virtualHost = "localhost";
    defaultUser = "admin";
    # Admin password, read at activation. Create it with:
    #   sudo install -d /etc/freshrss
    #   echo -n "your-password" | sudo tee /etc/freshrss/adminPassword
    passwordFile = "/etc/freshrss/adminPassword";
    # sqlite backend: no separate database server needed.
    database.type = "sqlite";
  };
}
