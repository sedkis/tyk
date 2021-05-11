package main

import (
	"bytes"
	"encoding/json"
	"github.com/TykTechnologies/tyk/ctx"
	"github.com/TykTechnologies/tyk/headers"
	"github.com/TykTechnologies/tyk/user"
	log "github.com/sirupsen/logrus"
	"net/http"
)

var client = &http.Client{}

func init() {
	log.Warning("init go plugin khara")
}

// Fill these in
var dashboardApiKey = "f83e3f9678ba434278d6b41cc1f184ca"
var dashboardBaseUrl = "http://host.docker.internal:3000"
var apiId = "0f5afb91dde24fe1490ba6e7125a4a24"  // Any API ID within this ORG, backwards compatibility reasons

func MyPluginAuthCheck(rw http.ResponseWriter, r *http.Request) {
	log.Info("Hello World")

	// try to get session by API key
	key := r.Header.Get(headers.Authorization)
	userSession := getSessionByKey(key)
	if userSession != nil {
		log.Info("Found Key")
		ctx.SetSession(r, userSession, key, true)
		return
	}

	// Business Logic here to determine if requester is allowed
	//if "i don't like you" {
	//	fmt.Println("Validate failed: ", string("Something broke!"))
	//	w.WriteHeader(http.StatusForbidden)
	//	_, _ = w.Write([]byte("Not allowed."))
	//	return
	//}

	// Create new Key
	log.Info("Creating new Key")
	keyData := createKey(key)
	keyData.Data.SetKeyHash(keyData.KeyHash)
	ctx.SetSession(r, keyData.Data, keyData.Key, true)
}

// Check if a key exists using the Dashboard APIs
func getSessionByKey(key string) *user.SessionState {
	log.Info("Looking for Key")
	req, _ := http.NewRequest("GET", dashboardBaseUrl + "/api/apis/" + apiId + "/keys/" + key, nil)
	resMsg := makeDashboardApiCall(req)
	if resMsg == nil || resMsg.Data == nil {
		log.Info("Key not found.")
		return nil
	}

	log.Info("Found key, hash: " + resMsg.KeyHash)
	return resMsg.Data
}

// Create key against Dashboard API
func createKey(token string) *KeyData {

	// Add the policies to the template, org id, and alias for easy lookups in Dashboard
	newSession := &user.SessionState{
		// Filler, required
		QuotaMax: 					-1,
		Allowance: 					0,
		Rate: 						0,
		Per: 						0,
		Tags: 						[]string{""},
		MetaData: 					make(map[string]interface{}),
		// Business Logic
		ApplyPolicies: 				[]string{"6099a9d1294c7b0001dbab8e", "5f83cfd378ab040001d3d824"},
		OrgID:                      "5e9d9544a1dcd60001d0ed20",
		Alias:                      token,
	}

	// convert it to JSON
	b, err := json.Marshal(newSession)
	if err != nil {
		log.Error("unmarshalling error.. ", err)
	}

	// Make API Call
	req, _ := http.NewRequest("POST", dashboardBaseUrl + "/api/keys/" + token, bytes.NewReader(b))
	resMsg := makeDashboardApiCall(req)

	return resMsg
}

type KeyData struct {
	Key     string `json:"key_id,omitempty"`
	KeyHash     string `json:"key_hash,omitempty"`
	Data  *user.SessionState `json:"data,omitempty"`
}

func makeDashboardApiCall(req *http.Request) *KeyData {
	req.Header.Add("Authorization", dashboardApiKey)
	resp, err := client.Do(req)
	if err != nil {
		log.Warn("Error making API Call ", err)
		return nil
	}

	buf := new(bytes.Buffer)
	_, _ = buf.ReadFrom(resp.Body)
	newStr := buf.String()

	if resp.StatusCode != 200 {
		log.Warn("response is bad: ", newStr)
	} else {
		//log.Info("response is good: ", newStr)
	}

	var resMsg KeyData
	err = json.Unmarshal([]byte(newStr), &resMsg)
	if err != nil {
		log.Warn("problems unmarshalling sir, ", err)
	}

	return &resMsg
}