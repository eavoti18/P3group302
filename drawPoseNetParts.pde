void drawPoseNetParts(JSONObject data){
  // Only if there are any humans detected
  if (data != null) {
    JSONArray humans = data.getJSONArray("poses");
    for(int h = 0; h < humans.size(); h++) {
      JSONArray keypoints = humans.getJSONArray(h);
      // Now that we have one human, let's draw its body parts
      for(int i = 0 ; i < connections.length; i++){
        
        JSONArray startPart = keypoints.getJSONArray(connections[i][0]);
        JSONArray endPart   = keypoints.getJSONArray(connections[i][1]);
        // extract floats fron JSON array and scale normalized value to sketch size
        float startX = startPart.getFloat(0) * width;
        float startY = startPart.getFloat(1) * height;
        float endX   = endPart.getFloat(0) * width;
        float endY   = endPart.getFloat(1) * height; 
        line(startX,startY,endX,endY);
      }
    }
  }
}
