realisticseasons_onseasonchange:
    type: world
    debug: false
    events:
        after internal bukkit event event:me.casperge.realisticseasons.api.SeasonChangeEvent:
        - run rs_change_webhook def.season:<context.reflect_event.read_field[newSeason]>

rs_change_webhook:
    type: task
    definitions: season
    debug: false
    script:
    - choose <[season]>:
        - case Spring:
            - define embed_title "¡Llegó la primavera!   :cherry_blossom: :rose: :bee:"
            - define embed_description "Aire fresco, flores, abejas y toda clase de animales.<n>Se esperan temperaturas entre `5°C-23°C`"
            - define image https://2775637040-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces<&pc>2F4p9wNXvzbAgtriQR5M18<&pc>2Fuploads<&pc>2FDDq3grnFF7q0gj6wdfVi<&pc>2F2022-02-20_18.22.34.png?alt=media&token=b2dd64d1-1c16-40b8-8316-462d2736d8d1
            - define embed_color <color[#F3A8BC].rgb_integer>
        - case Summer:
            - define embed_title "¡Ya es verano!   :sun_with_face: :sunglasses: :sunrise:"
            - define embed_description "Sol caliente, hojas secas, estrellas fugaces y luciérnagas.<n>:hotsprings: Se recomienda, tener hielo y agua cerca!! :ice_cube: :cup_with_straw:<n>Se esperan temperaturas entre `25°C-40°C`"
            - define image https://2775637040-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces<&pc>2F4p9wNXvzbAgtriQR5M18<&pc>2Fuploads<&pc>2FKpyTC3QBwvNV2k2995AR<&pc>2Fsummer.png?alt=media&token=91dbf5f8-57fb-458b-bdd6-893594be3a64
            - define embed_color <color[#15B2D3].rgb_integer>
        - case Fall:
            - define embed_title "¡Ya viene el otoño!   :fallen_leaf: :maple_leaf: :cloud_rain:"
            - define embed_description "Hojas cayendo y muchos tonos naranjas, aumentan las lluvias.<n>Temperatura: `5°C-25°C`"
            - define image https://2775637040-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces<&pc>2F4p9wNXvzbAgtriQR5M18<&pc>2Fuploads<&pc>2FcmSycnVbB647DeAkIYa4<&pc>2Ffall.png?alt=media&token=6e38852d-d356-4364-9615-9cf5cb83864b
            - define embed_color <color[#D45B12].rgb_integer>
        - case Winter:
            - define embed_title "¡Cayó el invierno!   :cloud_snow: :snowflake: :snowman2:"
            - define embed_description "Ahh, qué frío, todo nieve, todo hielo.<n>Se recomienda, antorchas y fogatas para no morir congelado!! :fire:<n>Por estos lugares el invierno es muy frío, no se porque `-10°C-5°C`<n><n>Dice una leyenda que…"
            - define image https://2775637040-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces<&pc>2F4p9wNXvzbAgtriQR5M18<&pc>2Fuploads<&pc>2Foj5WVFKhjwqBHpmwMoyk<&pc>2Fwinter.png?alt=media&token=e3b68c23-a7cb-44dc-95b5-127d09230d3f
            - define embed_color <color[#B3DAF1].rgb_integer>
    - definemap profile:
        avatar_url: https://cdn.discordapp.com/icons/866946932940210187/5d2b552bcf6121a0e530089e0967a10c.webp
        username: RealisticSeasons
    - definemap embed_data:
        title: <[embed_title]>
        description: <[embed_description]>
        color: <[embed_color]>
        image:
            url: <[image]>
    - define data <[profile].with[embeds].as[<list_single[<[embed_data]>]>]>
    - ~webget <secret[discord_webhook_url]> headers:<map[Content-Type=application/json;User-Agent=angw97]> data:<[data].to_json>

#Try to enable text highlight on github