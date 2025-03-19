package uk.ac.ucl.servlets;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import uk.ac.ucl.model.Tree;

@WebServlet("/newDir")
@MultipartConfig
public class NewDirServlet extends HttpServlet
{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String dirPath = request.getParameter("dirPath");
        String dirName = request.getParameter("dirName");

        if (dirPath == null || dirPath.isEmpty()) {
            dirPath = "root/";
        }

        ServletContext context = getServletContext();
        String jsonFilePath = context.getRealPath("/structure.json");
        
        // Load the tree structure from JSON
        Tree tree = new Tree(jsonFilePath);
        
        // Create the new directory in the tree structure
        tree.createDirectory(dirPath, dirName);
        
        // Save the updated tree structure back to JSON
        tree.saveToFile(jsonFilePath);
    }
}