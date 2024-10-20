class ArmaDeFilo{
  const filo
  const longitud

  method poderDeAtaque() = filo * longitud
}

class ArmaContundente{
  const peso 

  method poderDeAtaque() = peso
}

object casco{
  method puntos(gladiador) = 10
}

object escudo{
  method puntos(gladiador) = 5 + gladiador.destreza() * 0.1
}

class Mirmillones{
  var property vida = 100
  var property arma
  var property armadura
  var property fuerza

  method destreza() = 15

  method atacarA(gladiador) { 
    gladiador.recibirAtaque(self.poderDeAtaque())
    } 

  method poderDeAtaque() = arma.poderDeAtaque() + fuerza

  method recibirAtaque(valor){
    vida = (vida - valor).max(0)
  }

  method defensa() = armadura.puntos(self) + self.destreza()

  method pelear(gladiador) {
    self.atacarA(gladiador)
    gladiador.atacarA(self)
  }
  
  method puedePelear() = vida > 0

  method crearGrupoCon(gladiador){
    const nuevoGrupo new Grupo(nombre = "mirmillolandia", gladiadores= [self, gladiador])
    return nuevoGrupo
  }

  method curarse(){
    vida = vida + 30
  }
}

class Dimachaerus{
  var property vida = 100
  var property armas
  var property destreza

  method fuerza() = 10

  method atacarA(gladiador){
    gladiador.recibirAtaque(self.poderDeAtaque())
    destreza = destreza + 1
  }

  method poderDeAtaque() = self.fuerza() + self.poderDeArmas()

  method poderDeArmas() = armas.sum({a => a.poderDeAtaque()})

  method recibirAtaque(valor){
    vida = (vida - valor).max(0)
  }

  method defensa() = destreza / 2
  
  method pelear(gladiador) {
    self.atacarA(gladiador)
    gladiador.atacarA(self)
  }
  method puedePelear() = vida > 0

  method crearGrupoCon(nombre,gladiador){
    const sumaDePoderes = self.poderDeAtaque() + gladiador.poderDeAtaque()
    const nuevoGrupo new Grupo(nombre = "D-" + sumaDePoderes, gladiadores= [self, gladiador])
    return nuevoGrupo
  }
  method curarse(){
    vida = vida + 20
  }
}

class Grupo{
  const property nombre
  var property peleas = 0
  const property gladiadores = []

  method agregarMiembro(miembro){
    gladiadores.add(miembro)
  }

  method aumentarPeleas(){
      peleas = peleas + 1
  }

  method sacarMiembro(miembro){
    gladiadores.remove(miembro)
  }

  method combatir(otroGrupo){
        self.aumentarPeleas()
        otroGrupo.aumentarPeleas()
        (1..3).forEach({
            round=> 
            self.elMasFuerte().pelear(otroGrupo.elMasFuerte())
        })
    }

  method elMasFuerte() {
    const puedenPelear = gladiadores.filter({gladiador=> gladiador.puedePelear()})
        if(puedenPelear.isEmpty())
            self.error("No hay gladiadores que puedan pelear")
        
        return puedenPelear.max({gladiador=> gladiador.fuerza()})
    }
}

object coliseo {
  
  method combateEntreGrupos(unGrupo, otroGrupo){
    unGrupo.combatir(otroGrupo)
  }

  method combateGrupoContraGladiador(unGrupo, unGladiador){
    unGrupo.combatir(unGladiador)
  }

  method curarGladiador(gladiador){
    gladiador.curarse()
  }

  method curarGrupoDeGladiadores(unGrupo){
    unGrupo.gladiadores().forEach({g => g.curarse()})
  }
}
