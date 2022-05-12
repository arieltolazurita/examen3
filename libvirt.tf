
recurso  " libvirt_volume "  " xenial-qcow2 " {
  nombre =  " bionic.qcow2 "
  pool =  " predeterminado "  
  fuente =  " ./servidor-bionic-cloudimg-amd64.img "
  formato =  " qvaca2 "
}

datos  "  archivo_plantilla " " datos_usuario " {
  plantilla =  " ${ archivo ( " ${ ruta . módulo } /cloud_init.cfg " ) } "
}


recurso  " libvirt_cloudinit_disk "  " commoninit " {
  nombre =  " commoninit.iso "
  pool =  " predeterminado "  # Lista de pools de almacenamiento usando virsh pool-list
  user_data =  " ${ datos . template_file . user_data . renderizado } "
}

# Definir dominio KVM para crear
recurso  " libvirt_domain "  " xenial " {
  nombre    =  " biónico "
  memoria =  " 1024 "
  vcpu    =  1

  interfaz_red {
    network_name =  " default "  # Lista de redes con virsh net-list
    esperar_por_alquiler =  verdadero
  }

  disco {
    id_volumen =  " ${ libvirt_volumen . xenial-qcow2 . id } "
  }

  cloudinit =  " ${ libvirt_cloudinit_disk . commoninit . id } "

  consola {
    tipo =  " pty "
    target_type =  " serie "
    destino_puerto =  " 0 "
  }

  gráficos {
    tipo =  " especia "
    listen_type =  " dirección "
    autoportar =  verdadero
  }
}

# IP del servidor de salida
  salida  " ip " {
    valor =  " ${ libvirt_domain . xenial . network_interface . 0 . direcciones . 0 } "
}