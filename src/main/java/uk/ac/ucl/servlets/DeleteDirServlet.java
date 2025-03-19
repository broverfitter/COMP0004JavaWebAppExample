package uk.ac.ucl.servlets;

import jakarta.servlet.RequestDispatcher;
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

@WebServlet("/deleteDir")
public class DeleteDirServlet extends HttpServlet
{
  private void emptyDeletedNode(DirectoryNode node, ServletContext context) {
    for (Object child : node.getChildren()) {
        if (child instanceof DirectoryNode) {
            DirectoryNode dirNode = (DirectoryNode) child;
            emptyDeletedNode(dirNode, context);
        } else if (child instanceof NoteNode) {
            NoteNode noteNode = (NoteNode) child;
            String noteName = noteNode.getFname();
            
            String notePath = context.getRealPath("/notes/" + noteName);
            System.out.println("Deleting note: " + notePath);
            java.io.File file = new java.io.File(notePath);
            file.delete();
        }
    }
  }
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
            // This function receives the path needs to do different things depending on note or directory

            String dirPath = request.getParameter("dirPath");

            ServletContext context = getServletContext();
        
            // Load the tree structure
            String jsonFilePath = context.getRealPath("/structure.json");
            Tree tree = new Tree(jsonFilePath);
            DirectoryNode root = tree.getRoot();

            DirectoryNode deletedNode = root.findAndDeleteDir(dirPath);

            // delete all files from /notes
            emptyDeletedNode(deletedNode, context);

            tree.saveToFile(jsonFilePath);

            response.setContentType("text/json");
            PrintWriter out = response.getWriter();
            
            out.println("{\"status\": \"success\"}");
  }
}