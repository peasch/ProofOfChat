package com.example.backend.repositories;

import com.example.backend.entities.Talk;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TalkRepository extends JpaRepository<Talk,Long> {

}
