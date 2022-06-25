package org.danixy8.springcloud.msvc.usuarios.repositories;

import org.danixy8.springcloud.msvc.usuarios.models.entity.Usuario;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface UsuarioRepository extends CrudRepository<Usuario, Long> {
    //dos formas de hacer metodos personalizados en JPA, tema de gustos
    //en el primero es importante la forma en que nombramos al metodo, ejemplo 'findBy'
    //en la segunda es importante formular la query como indica la documentacion de jpa
    //la tercera forma es mas simple sin embargo debe modificarse la interfaz y la implementacion
    Optional<Usuario> findByEmail(String email);

    @Query("select u from Usuario u where u.email=?1")
    Optional<Usuario> porEmail(String email);

    boolean existsByEmail(String email);
}
