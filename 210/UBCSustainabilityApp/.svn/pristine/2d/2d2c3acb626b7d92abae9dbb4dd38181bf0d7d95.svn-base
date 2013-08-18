package ubc.cs.cpsc210.sustainabilityapp.webservices;

import java.io.IOException;
import java.util.LinkedList;

import java.util.List;

import org.json.JSONException;
import org.json.JSONTokener;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import ubc.cs.cpsc210.sustainabilityapp.model.Photograph;
import ubc.cs.cpsc210.sustainabilityapp.model.LatLong;
import ubc.cs.cpsc210.sustainabilityapp.webservices.FlickrService;

/**
 * Creates Photographs from Flickr data; populates photo with LatLong info
 * @authors UBC CPSC 210: Daniel Vasqeuz and Andrew Gormley
 */

public class FlickrParser {
	
	/**
	 * Parses a JSON-formatted response from Flickr API method flickr.photos.search and 
	 * returns a corresponding list of Photograph
	 * 
	 * REQUIRES: response in a JSON-formatted string from flickr.photos.search
	 * EFFECTS: Extracts the values from response fields "id","title", "farm", "secret", "owner", and
	 *          "server" in each photo, builds a list of Photograph and returns it
	 */
	public static List<Photograph> parse(String response) {
		System.out.println("Entering FlickrParser.parse...");
		
		LinkedList<Photograph> photoIDs = new LinkedList<Photograph>();
		JSONObject obj = (JSONObject) JSONValue.parse(getJSONFromResponse(response));

		// TODO Project Phase Two : Now that you have a String that represents a JSONObject,
		// parse the string to return a List of Photographs
		JSONObject photosObj = (JSONObject)       obj.get("photos"); //get method inherited from HashMap
		JSONArray  photoArr  = (JSONArray)  photosObj.get("photo");  //JSONArray is sublass of ArrayList
		
		//Print lines for debugging:
//		System.out.println("photosObj: " + photosObj);
//		System.out.println("photoArr: "+photoArr);
//		System.out.println("photoIDs before loop: " + photoIDs);
//		System.out.println("Entering photoArr loop...");

		// Iterate through each photo in photoArr to extract values for Photograph arguments
		for (int i=0; i < photoArr.size(); i++) {
			JSONObject photo = (JSONObject) photoArr.get(i);

			String id          = String.valueOf(photo.get("id"));
			String displayName = String.valueOf(photo.get("title"));
			String farm        = String.valueOf(photo.get("farm")); //convert int to string
			String secret      = String.valueOf(photo.get("secret"));
			String owner       = String.valueOf(photo.get("owner"));
			String server      = String.valueOf(photo.get("server"));
			Photograph pTemp = new Photograph(id, displayName, farm, secret, owner, server);
			// Use the parseLocation method to get add LatLong to photo
			try {
				pTemp.setLatLong(parseLocation(FlickrService.getLocation(id)));
			} catch (IOException e) {
				System.out.println("IOException caught in FlickrParser.parse");
				e.printStackTrace();
			}
			photoIDs.add(pTemp);
		}
		
		//Print lines for debugging:
//		System.out.println("photoIDs after loop: " + photoIDs);
//		System.out.println(photoIDs.get(0).getDisplayName() + "\n" + 
//						     photoIDs.get(0).getURL() + "\n"+ 
//						     photoIDs.get(0).getDescription());
//		System.out.println("Exiting FlickrParser.parse...");
		return photoIDs;
	}
	/**
	 * Parses a JSON-formatted response from Flickr API method by extracting lat-long values from
	 * flickr.photos.geo.getLocation and returns a corresponding list of Photograph
	 * 
	 * REQUIRES: response in a JSON-formatted string from flickr.photos.geo.getLocation
	 * EFFECTS: Extracts the values from response fields "latitude" and "longitude" in 
	 *          a photo, and returns a LatLong
	 */
	private static LatLong parseLocation(String response){ 
		System.out.println("Entered FlickrParser.parseLocation...");
		String json = getJSONFromResponse(response);

		// TODO Project Phase Two : Now that you have a String that represents a JSON Object,
		// parse the string and return the LatLong 
		
		JSONObject obj         = (JSONObject) JSONValue.parse(json);
		JSONObject photoObj    = (JSONObject)      obj.get("photo");     //JSONObject is subclass of HashMap, use get method
		JSONObject locationObj = (JSONObject) photoObj.get("location");
		Double lat             = (Double)  locationObj.get("latitude");
		Double lon             = (Double)  locationObj.get("longitude");
		
		
		//Print lines for debugging:
//		System.out.println("obj: "+ obj);
//		System.out.println("photoObj: "+ photoObj);
//		System.out.println("locationObj: "+ locationObj);
//		System.out.println("lat: "+ lat);
//		System.out.println("lon: "+ lon);
		
		LatLong result = new LatLong(lat, lon);

		System.out.println("returning new LatLong(" + result.getLatitude() + ", " + result.getLongitude() + ")");
		System.out.println("Exiting FlickrParser.parseLocation...");
		return result;
	}

	private static String getJSONFromResponse(String response){
		return response.substring(14, response.length() -1);
	}


	///////// Code below is for TestFlickrParser JUnit testing purposes
/*	static JSONObject parseLocationPhoto(String response){ 
		String json = getJSONFromResponse(response);
		JSONObject obj = (JSONObject) JSONValue.parse(json);
		return obj;
	}*/

}

