# El Templo Animal · eltemploanimal.com

Landing estática de **El Templo Animal**, tienda de productos para mascotas en Marbella.

- Web: https://eltemploanimal.com
- Dirección: Av. Arias de Velasco, 37, 29601 Marbella, Málaga
- Teléfono: 629 44 10 49

## Estructura

- `public/` — contenido publicado en el dominio. El servidor sincroniza únicamente esta carpeta.
- `deploy/` — scripts de publicación usados en el VPS.

## Publicación

El VPS de Virtualmin mantiene un checkout en `/home/eltemploanimal/website-source` y revisa `origin/main` cada 5 minutos. Cuando hay commits nuevos:

1. `check-and-publish.sh` detecta el cambio.
2. `publish-site.sh` hace `git pull --ff-only`.
3. Copia `public/` sobre `/home/eltemploanimal/public_html` con `rsync` sin `--delete`.
4. Guarda una copia de seguridad y conserva las 10 últimas.

Los scripts viven en `/home/eltemploanimal/check-and-publish.sh` y `/home/eltemploanimal/publish-site.sh`, y se ejecutan con el usuario del dominio.

No hay formulario de contacto: los datos están publicados como texto y enlaces.
