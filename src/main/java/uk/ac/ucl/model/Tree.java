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
        this.root = parseDirectoryNode(rootNode, "");
    }
    
    private DirectoryNode parseDirectoryNode(JsonNode node, String path) {
        String newpath = path + node.get("name").asText() + "/";
        DirectoryNode directoryNode = new DirectoryNode(node.get("name").asText(), newpath);
        for (JsonNode childNode : node.get("children")) {
            if (childNode.has("fpath")) {
                NoteNode noteNode = new NoteNode(childNode.get("fpath").asText(), childNode.get("title").asText(), newpath);
                directoryNode.addChild(noteNode);
            } else {
                directoryNode.addChild(parseDirectoryNode(childNode, newpath));
            }
        }
        return directoryNode;
    }

    public DirectoryNode getRoot() {
        return root;
    }

    public int saveNote(String fname, String title, String path) {
        NoteNode noteNode = new NoteNode(fname, title, path);
        DirectoryNode directoryNode = root.findDirectory(path);
        if (directoryNode != null) {
            directoryNode.addChild(noteNode);
            return 0;
        } else {
            return -1;
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
        
        // Create empty children array first - this is the crucial fix
        node.putArray("children");
        
        // Then add children to it if they exist
        for (Object child : directoryNode.getChildren()) {
            if (child instanceof DirectoryNode) {
                node.withArray("children").add(serializeDirectoryNode((DirectoryNode) child));
            } else if (child instanceof NoteNode) {
                NoteNode noteNode = (NoteNode) child;
                ObjectNode noteNodeJson = mapper.createObjectNode();
                noteNodeJson.put("fpath", noteNode.getFname());
                noteNodeJson.put("title", noteNode.getTitle());
                node.withArray("children").add(noteNodeJson);
            }
        }
        return node;
    }
}