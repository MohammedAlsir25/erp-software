{pkgs}: {
  channel = "stable-24.05";
  packages = [
    pkgs.flutter,
    pkgs.flutter319,
    pkgs.jdk17,
    pkgs.unzip
  ];
  idx.extensions = [
    
  ];
  idx.previews = {
    previews = {
      web = {
        command = [
          "flutter",
          "run",
          "-d",
          "windows"
        ];
      };
    };
  };
}
