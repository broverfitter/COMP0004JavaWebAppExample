package uk.ac.ucl.model;

import java.io.File;
import java.io.IOException;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

public class Tree {
    private DirectoryNode root;

    public Tree(String jsonFilePath) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        JsonNode rootNode = mapper.readTree(new File(jsonFilePath));
        this.root = parseDirectoryNode(rootNode);
    }
    
    private DirectoryNode parseDirectoryNode(JsonNode node) {
        DirectoryNode directoryNode = new DirectoryNode(node.get("name").asText());
        for (JsonNode childNode : node.get("children")) {
            if (childNode.has("fpath")) {
                NoteNode noteNode = new NoteNode(childNode.get("fpath").asText(), childNode.get("title").asText());
                directoryNode.addChild(noteNode);
            } else {
                directoryNode.addChild(parseDirectoryNode(childNode));
            }
        }
        return directoryNode;
    }

    public DirectoryNode getRoot() {
        return root;
    }

    public void addDirectory(String parentDirName, String dirName) {
        DirectoryNode parentDir = root.findDirectory(parentDirName);
        if (parentDir != null) {
            parentDir.addChild(new DirectoryNode(dirName));
        } else {
            System.out.println("Parent directory not found");
        }
    }

    public void addNote(String parentDirName, String fpath, String title) {
        DirectoryNode parentDir = root.findDirectory(parentDirName);
        if (parentDir != null) {
            parentDir.addChild(new NoteNode(fpath, title));
        } else {
            System.out.println("Parent directory not found");
        }
    }

    public void saveToFile(String jsonFilePath) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode rootNode = serializeDirectoryNode(root);
        mapper.writerWithDefaultPrettyPrinter().writeValue(new File(jsonFilePath), rootNode);
    }

    private ObjectNode serializeDirectoryNode(DirectoryNode directoryNode) {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode node = mapper.createObjectNode();
        node.put("name", directoryNode.getName());
        for (Object child : directoryNode.getChildren()) {
            if (child instanceof DirectoryNode) {
                node.withArray("children").add(serializeDirectoryNode((DirectoryNode) child));
            } else if (child instanceof NoteNode) {
                NoteNode noteNode = (NoteNode) child;
                ObjectNode noteNodeJson = mapper.createObjectNode();
                noteNodeJson.put("fpath", noteNode.getFpath());
                noteNodeJson.put("title", noteNode.getTitle());
                node.withArray("children").add(noteNodeJson);
            }
        }
        return node;
    }
}