#Installation

Installation process and required software.

##Main host
One main host must be the controller.
* Software required on the main host: 
   * SSH client software.
   * `rake --version` =>10.1.0
   * `ruby -v` => 1.9.3p194
* Installation process:
   * Download this project
   * `cd sysadmin-game`
   * Execute `rake install_gems` to install required gem on your system.

##Remote hosts
Several remote hosts to be monitorized.
* Software required on every remote host:
   * SSH server software installed on remote machines.
   * Superuser password must be known by the teacher..
