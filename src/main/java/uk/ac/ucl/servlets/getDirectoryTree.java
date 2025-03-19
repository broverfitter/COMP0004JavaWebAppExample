package uk.ac.ucl.servlets;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

import uk.ac.ucl.model.Tree;
import uk.ac.ucl.model.DirectoryNode;
import uk.ac.ucl.model.NoteNode;

@WebServlet("/getDirectoryTree")
public class getDirectoryTree extends HttpServlet {
    
    // HTML generation for directory nodes
    private String HTMLForDirNode(DirectoryNode node) {
        StringBuilder html = new StringBuilder();
        html.append("<li class='dirNode'>")
            .append("<span class='toggle'>></span> ")
            .append(String.format("<span class='dirToggle' id='%s'>%s</span>", node.getPath(), node.getName()))
            .append("<ul class='children'>");
        return html.toString();
    }
    
    // HTML generation for note nodes
    private String HTMLForNoteNode(NoteNode node) {
        return String.format("<li class='noteNode'>| <a class='noteLink' href='#' id='%s'>%s</a></li>", 
                node.getFname(), node.getTitle());
    }
    
    // Recursive method to generate HTML for the directory tree
    private String getTreeHtml(Object node, boolean isRoot) {
        if (node == null) return "";
        StringBuilder html = new StringBuilder();
        if (isRoot) {
            DirectoryNode dirNode = (DirectoryNode) node;
            for (Object child : dirNode.getChildren()) {
                html.append(getTreeHtml(child, false));
            }
        } else {
            if (node instanceof DirectoryNode) {
                DirectoryNode dirNode = (DirectoryNode) node;
                html.append(HTMLForDirNode(dirNode));
                for (Object child : dirNode.getChildren()) {
                    html.append(getTreeHtml(child, false));
                }
                html.append("</ul></li>");
            } else if (node instanceof NoteNode) {
                NoteNode noteNode = (NoteNode) node;
                html.append(HTMLForNoteNode(noteNode));
            }
        }
        return html.toString();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ServletContext context = getServletContext();
        
        // Load the tree structure
        String jsonFilePath = context.getRealPath("/structure.json");
        Tree tree = new Tree(jsonFilePath);
        DirectoryNode root = tree.getRoot();
        
        // Generate HTML for the directory tree
        String directoryTreeHtml = getTreeHtml(root, true);
        
        // Set content type and return the HTML
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(directoryTreeHtml);
        out.flush();
    }
}