package uk.ac.ucl.model;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.File;
import java.io.IOException;

public class JsonStructure {
    private String fpath;

    public JsonStructure(String fpath) {
        this.fpath = fpath;
        
    }
}