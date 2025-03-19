package uk.ac.ucl.model;

import java.util.ArrayList;
import java.util.List;

public class DirectoryNode {
    private String name;
    private List<Object> children;
    private String path;

    public DirectoryNode() {
        this.children = new ArrayList<>();
    }

    public DirectoryNode(String name, String path) {
        this.name = name;
        this.children = new ArrayList<>();
        this.path = path;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Object> getChildren() {
        return children;
    }

    public String getPath() {
        return path;
    }

    public void setChildren(List<Object> children) {
        this.children = children;
    }

    public void addChild(Object child) {
        this.children.add(child);
    }

    public DirectoryNode findDirectory(String path) {
        // Check if this is a request for the root directory
        if (path == null || path.isEmpty() || path.equals("root/")) {
            return this;  // Return the root node itself
        }
        
        // Existing path handling code for subdirectories
        if (this.path.equals(path)) {
            return this;
        }
        for (Object child : children) {
            if (child instanceof DirectoryNode) {
                DirectoryNode directoryNode = (DirectoryNode) child;
                DirectoryNode result = directoryNode.findDirectory(path);
                if (result != null) {
                    return result;
                }
            }
        }
        return null;
    }

    public NoteNode findNoteChild(String fname) {
        for (Object child : children) {
            if (child instanceof NoteNode) {
                NoteNode noteNode = (NoteNode) child;
                if (noteNode.getFname().equals(fname)) {
                    return noteNode;
                }
            }
        }
        return null;
    }

    public void findAndDeleteChild(String fname) {
        for (Object child : children) {
            if (child instanceof NoteNode) {
                NoteNode noteNode = (NoteNode) child;
                if (noteNode.getFname().equals(fname)) {
                    children.remove(child);
                    return;
                }
            }
            else if (child instanceof DirectoryNode) {
                DirectoryNode directoryNode = (DirectoryNode) child;
                directoryNode.findAndDeleteChild(fname);
            }
        }
    }

    public DirectoryNode findAndDeleteDir(String path) {
        // get rid of 'root/'
        path = path.substring(5);
        String remainingPath = path.substring(path.indexOf("/") + 1);
        String nextDir = path.substring(0, path.indexOf("/") + 1);

        for (Object child : children) {
            if (child instanceof DirectoryNode) {
                DirectoryNode directoryNode = (DirectoryNode) child;
                if ((directoryNode.getName() + "/").equals(nextDir)) {
                    if (remainingPath.equals("")) {     
                        children.remove(child);
                        return directoryNode;
                    }
                    else {
                        directoryNode.findAndDeleteDir(remainingPath);
                    }
                }
            }
        }
        return null;
    }
}