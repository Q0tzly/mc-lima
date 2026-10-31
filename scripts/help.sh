#!/usr/bin/env bash
# Display mc-lima command reference and usage guide

cat << 'EOF'

 [1;36m=============================================================== [0m
 [1;32m   mc-lima - Minecraft Server on Lima & mise [0m
 [1;36m=============================================================== [0m

 [1;33mUSAGE: [0m
  mise run <command> [arguments...]

 [1;33mAVAILABLE COMMANDS: [0m
   [1;32mup [0m                   Start Lima VM and Minecraft Server
   [1;32mdown [0m                 Stop Minecraft Server and shut down Lima VM
                       Option:  [0;36m--keep-vm [0m (stop server container only)
   [1;32mrestart [0m              Restart Minecraft Server container (e.g. reload config)
   [1;32mstatus [0m               Show status of VM, container, and port connectivity
   [1;32mip [0m                   Show connection IP addresses (localhost & Wi-Fi LAN IP)
   [1;32mlogs [0m                 Follow server logs in real-time (Ctrl+C to exit)
   [1;32mconsole [0m              Open interactive Minecraft server console (rcon-cli)
   [1;32mrcon "<command>" [0m     Execute a one-shot Minecraft command via RCON
                       Example:  [0;36mmise run rcon "op Steve" [0m
   [1;32mbackup [0m               Create a timestamped backup of ./data in ./backups/
   [1;32mshell [0m                Open an interactive Linux shell inside the Lima VM
   [1;32mdestroy [0m              Delete the Lima VM (world data in ./data is retained)
   [1;32minit [0m                 Initialize .env and necessary directories
   [1;32mhelp [0m                 Display this help reference

 [1;33mDATA & CONFIGURATION: [0m
   [1;37m.env [0m                 Server settings (type, version, memory, port, etc.)
   [1;37m./data/ [0m              Mounted server files (world, server.properties, plugins)
   [1;37m./data/plugins/ [0m      Place plugin .jar files here and run 'mise run restart'
   [1;37m./backups/ [0m           Backup archives created by 'mise run backup'

 [1;33mQUICK START: [0m
  1.  [0;36mmise run up [0m        (Start server)
  2. Connect to  [1;35mlocalhost:25565 [0m in your Minecraft client
  3.  [0;36mmise run console [0m   (Give yourself OP permissions: 'op <username>')
  4.  [0;36mmise run down [0m      (Stop server and free resources)

 [1;36m=============================================================== [0m

EOF
