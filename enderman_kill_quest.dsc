npc_ass_guild0:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:3
        - trigger name:chat state:true
        - trigger name:click state:true
    interact scripts:
    - npc_interact_guild0

npc_interact_guild0:
    type: interact
    steps:
        default*:
            proximity trigger:
                entry:
                    script:
                    - narrate "<&d><&l>Eventos -<&gt> Hola, <player.display_name> <&d>(❁´◡`❁)!"
                    - narrate "<&d>¿Como estas?"

            click trigger:
                script:
                - if <player.has_flag[kill_enderman_count]>:
                    - narrate "<&b>¿Como va la caseria de enderman?"
                - else:
                    - narrate "<&b>Escrie <&dq>eventos<&dq> para ver los eventos disponibles!!"

            chat trigger:
                1:
                    trigger: /eventos/
                    hide trigger message: true
                    script:
                    - if <npc.has_flag[no_event]>:
                        - narrate "<&b>No hay eventos o se acabaron...<&c>＞︿＜"
                    - if <player.has_flag[kill_enderman_count]>:
                        - narrate "<&b>Escribe <&dq>portal<&dq> para reclamar tu premio"
                        - stop
                    - else:
                        - narrate "<&b>Evento disponible: <&color[#663399]>PORTAL!!"
                        - narrate "<&b>Escribe <&dq>portal<&dq> si deseas entar!"

                2:
                    trigger: /portal/
                    hide trigger message: true
                    script:
                    - if <npc.has_flag[no_event]>:
                        - narrate "<&5>Evento terminado"
                        - narrate "<&5>Premios?, recojelos en delivery"
                        - narrate "<&5>Fondo a la derecha."
                        - stop
                    - if <player.has_flag[kill_enderman_count]>:
                        - narrate "<&5>Continua cazando!!"
                        - stop
                    - title "title:<&color[#663399]>Evento Portal!!!" "subtitle:<&color[#9400D3]>Acaba con los enderman!!!"
                    - narrate "<&color[#663399]>Has activado el evento portal del Nether<n>debes ser el primero en acabar con 10 <&color[#4B0082]>enderman"
                    - flag player kill_enderman_count:0
                    - define embed "<discord_embed.with_map[title=<player.name> Ha ingresado al evento **Portal del NETHER**;color=#6A5ACD]>"
                    - ~discordmessage id:discord_bot channel:<server.flag[discord_wonder]> <[embed]>
                    - else:
                        - stop

kill_enderman_event:
    type: world
    events:
        after player kills enderman flagged:kill_enderman_count:
        - if !<player.has_flag[kill_enderman_count]> || <npc[<server.flag[npc_event]>].has_flag[no_event]>:
            - stop
        - flag player kill_enderman_count:++
        - announce "<&c><player.display_name> <&5>Lleva <&9><player.flag[kill_enderman_count]> <&5>enderman"
        - ~discordmessage id:discord_bot channel:<server.flag[discord_wonder]> "<discord_embed.with_map[title=<player.name> lleva **<player.flag[kill_enderman_count]>** enderman;color=#6A5ACD]>"
        - if <player.flag[kill_enderman_count]> == 10:
            - if <player.has_flag[portal_winner]>:
                - stop
            - define npc <npc[<server.flag[npc_event]>]>
            - title "title:<&color[#663399]>Has Ganado!!!" "subtitle:<&color[#9400D3]>Has activado el NETHER"
            - firework <player.location> power:2 primary:<color[#663399]> fade:white trail
            - define embed "<discord_embed.with_map[title=<player.name> Ha completado el evento portal del nether;description=Ahora <player.name> guiará a todos hacia esta misteriosa dimensión con el libro!!<n>(Pueden pedirle prestado el libro XD);thumbnail=https://crafthead.net/avatar/<player.uuid>/64;color=#6A5ACD]>"
            - ~discordmessage id:discord_bot channel:<server.flag[discord_wonder]> <[embed]>
            - flag player portal_winner
            - flag <npc[<server.flag[npc_event]>]> no_event
            - adjust <[npc]> "hologram_lines:<npc[<[npc]>].hologram_lines.set[<&c>Nada ¯\_(ツ)_/¯].at[1]>"
            - wait 2s
            - drop item_thenetherbook <player.location.forward_flat>
            - narrate "<&color[#663399]>Toma el libro!!"

kill_enderman_event_death:
    type: world
    debug: false
    events:
        on player death flagged:kill_enderman_count by:enderman:
        - determine KEEP_INV
        - determine KEEP_LEVEL
        - determine NO_DROPS
        - determine NO_XP