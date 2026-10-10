# Arquitectura del proyecto integrador en Azure Lab 2

Este repositorio contiene la implementación reproducible de la práctica **Azure Lab 2**. La arquitectura se preparó a partir de los trece videos, la hoja `Red y subredes.xlsx` y el archivo `Creacion BD Integradora.txt` publicados por el profesor.

La práctica se desplegó en una suscripción Azure for Students. La región inicial indicada por el material era México Central, pero una directiva de la suscripción rechazó PostgreSQL y los puntos de conexión privados en esa región. Para terminar la práctica sin cambiar su objetivo, todos los recursos nuevos se desplegaron de forma consistente en **Chile Central**.

## Arquitectura implementada

- Una red virtual `10.0.0.0/16` con cinco subredes.
- Una VM Windows Server 2025 sin dirección IP pública.
- Azure Database for PostgreSQL Flexible Server 18 con la base `integradora`.
- Una cuenta StorageV2 con contenedor Blob `smartrh`.
- Dos Private Endpoints y sus zonas DNS privadas para PostgreSQL y Blob.
- Un App Service Linux B1 con Node.js 24 LTS e integración de red virtual.
- Log Analytics y Application Insights.
- Cuatro grupos de seguridad de red y etiquetas comunes de gobierno.

## Subredes

| Subred | CIDR | Uso |
|---|---:|---|
| `snet-utvt-integradora-lab2-app-dev-clc-001` | `10.0.1.0/24` | Integración de App Service |
| `snet-utvt-integradora-lab2-db-dev-clc-001` | `10.0.2.0/24` | Private Endpoint de PostgreSQL |
| `snet-utvt-integradora-lab2-vm-dev-clc-001` | `10.0.3.0/24` | Máquina virtual |
| `snet-utvt-integradora-lab2-pe-dev-clc-001` | `10.0.4.0/24` | Private Endpoint de Blob |
| `AzureBastionSubnet` | `10.0.5.0/26` | Reserva válida para Azure Bastion |

## Seguridad aplicada

- PostgreSQL y Storage tienen el acceso público deshabilitado.
- Los servicios privados se resuelven mediante zonas DNS `privatelink`.
- La VM no publica una IP de Internet y usa Trusted Launch, Secure Boot y vTPM.
- La Web App obliga HTTPS, TLS 1.2 y deshabilita FTPS.
- Storage exige transferencia segura, TLS 1.2 y conserva blobs y contenedores eliminados durante siete días.
- Ninguna contraseña, token, estado ni archivo local de parámetros se publica en Git.

## Ejecución

Se requiere Azure CLI con Bicep y una sesión iniciada en la suscripción correcta.

```bash
export RESOURCE_GROUP='rg-utvt-integradora-lab2-dev-clc-001'
export UNIQUE_SUFFIX='un-sufijo-unico'
export VM_ADMIN_PASSWORD='una-contrasena-temporal-segura'
export POSTGRES_ADMIN_PASSWORD='otra-contrasena-temporal-segura'

./scripts/validate.sh
./scripts/deploy.sh
```

Las contraseñas deben entregarse mediante variables de entorno o un almacén seguro. No deben escribirse en archivos versionados.

## Resultados de la ejecución realizada

- Grupo de recursos: `rg-utvt-integradora-lab2-dev-clc-001`
- Recursos detectados por Azure CLI: 22, incluidos recursos secundarios.
- Recursos principales mostrados en el portal: 20.
- App Service: `app-utvt-integradora-lab2-bb10100030`
- PostgreSQL: `psql-utvt-integradora-lab2-bb10100030`
- Storage: `stutvtlab2bb10100030`
- Base de datos: `integradora`

Después de recopilar evidencias se detuvieron la VM, PostgreSQL y la Web App para reducir el consumo. El plan App Service B1 y los demás servicios permanecen creados; para eliminar todos los cargos es necesario borrar el grupo de recursos de forma consciente. Este repositorio no ejecuta `destroy` ni elimina recursos automáticamente.

## Relación con SMART RH

PostgreSQL y Blob se implementaron como ejercicio de arquitectura de Azure. Esto no significa que la aplicación SMART RH haya migrado su persistencia: el proyecto real continúa usando MySQL y MongoDB. La práctica sirve como una propuesta aislada para estudiar red privada, cómputo, monitoreo y servicios PaaS.

