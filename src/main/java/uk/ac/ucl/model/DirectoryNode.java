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
}