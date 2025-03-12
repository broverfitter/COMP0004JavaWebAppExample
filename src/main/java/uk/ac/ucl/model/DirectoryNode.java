package uk.ac.ucl.model;

import java.util.ArrayList;
import java.util.List;

public class DirectoryNode {
    private String name;
    private List<Object> children;

    public DirectoryNode() {
        this.children = new ArrayList<>();
    }

    public DirectoryNode(String name) {
        this.name = name;
        this.children = new ArrayList<>();
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

    public void setChildren(List<Object> children) {
        this.children = children;
    }

    public void addChild(Object child) {
        this.children.add(child);
    }

    public DirectoryNode findDirectory(String name) {
        if (this.name.equals(name)) {
            return this;
        }
        for (Object child : children) {
            if (child instanceof DirectoryNode) {
                DirectoryNode found = ((DirectoryNode) child).findDirectory(name);
                if (found != null) {
                    return found;
                }
            }
        }
        return null;
    }
}