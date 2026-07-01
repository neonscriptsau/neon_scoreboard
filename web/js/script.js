let showingRobberies = false;

function createJobCard(jobKey, config) {
    const div = document.createElement("div");
    div.classList.add("service");
    div.id = `job-${jobKey}`;
    div.dataset.high = config.high;
    div.dataset.medium = config.medium;

    div.innerHTML = `
        <div class="text-center">
            <h2>${config.title}</h2>
        </div>
        <div class="signal-bar">
            <div class="bars">
                <span class="bar bar1"></span>
                <span class="bar bar2"></span>
                <span class="bar bar3"></span>
            </div>
            <span class="status-label"></span>
        </div>
    `;

    return div;
}

function fillBars(container, count) {
    const bars = container.querySelectorAll(".bar");
    bars.forEach((bar, index) => {
        if (index < count) bar.classList.add("filled");
        else bar.classList.remove("filled");
    });
}

function renderServices(data) {
    const services = document.querySelector(".services");
    services.innerHTML = "";
    document.getElementById("services-title").textContent = "Whitelisted Services";

    data.jobs.forEach(jobConfig => {
        const jobKey = jobConfig.key;
        const jobCount = data.counts[jobKey] || 0;
        const card = createJobCard(jobKey, jobConfig);
        const signalBar = card.querySelector(".signal-bar");
        const statusLabel = card.querySelector(".status-label");

        const isPolice = jobKey === "police";

        if (jobCount === 0 && !isPolice) {
            card.classList.add("low");
            signalBar.classList.add("low");
            statusLabel.textContent = "Unavailable";
            fillBars(card, 0);
        } else if (jobCount >= jobConfig.high) {
            card.classList.add("high");
            signalBar.classList.add("high");
            statusLabel.textContent = "High";
            fillBars(card, 3);
        } else if (jobCount >= jobConfig.medium) {
            card.classList.add("medium");
            signalBar.classList.add("medium");
            statusLabel.textContent = "Medium";
            fillBars(card, 2);
        } else {
            card.classList.add("low");
            signalBar.classList.add("low");
            statusLabel.textContent = "Low";
            fillBars(card, 1);
        }

        services.appendChild(card);
    });
}

function renderRobberies(data) {
    const services = document.querySelector(".services");
    services.innerHTML = "";
    document.getElementById("services-title").textContent = "Robbery Status";

    data.forEach(robbery => {
        const div = document.createElement("div");
        div.classList.add("service");

        const active = robbery.current >= robbery.required;
        div.classList.add(active ? "high" : "low");

        div.innerHTML = `
            <div class="text-center">
                <h2>${robbery.title}</h2>
            </div>
            <div class="signal-bar ${active ? "high" : "low"}">
                <div class="bars">
                    <span class="bar bar1 ${active ? "filled" : ""}"></span>
                    <span class="bar bar2 ${active ? "filled" : ""}"></span>
                    <span class="bar bar3 ${active ? "filled" : ""}"></span>
                </div>
                <span class="status-label">${active ? "Online" : "Offline"}</span>
            </div>
        `;

        services.appendChild(div);
    });
}

window.addEventListener("message", (event) => {
    const data = event.data;
    const container = document.querySelector(".container");

    if (data.action === "show") {
        container.classList.add("active");
    }

    if (data.action === "hide") {
        container.classList.remove("active");

        showingRobberies = false;
        document.getElementById("robbery-button").innerHTML =
            '<span class="stat-label">Robbery</span><span class="stat-value">Status</span>';
        document.getElementById("services-title").textContent = "Whitelisted Services";
    }
    
    if (data.action === "updatePlaytime") {
        document.getElementById("playtime").textContent = data.playtime;
    }

    if (data.action === "updateData") {
        document.getElementById("players").textContent = `${data.total}/${data.slots}`;
        document.getElementById("uptime").textContent = data.uptime;
        renderServices(data);
    }

    if (data.action === "updateRobberies") {
        renderRobberies(data.robberies);
    }
});

// ESC closes UI
document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/closeUI`, { method: "POST" });
    }
});

document.addEventListener("DOMContentLoaded", () => {
    const robberyBtn = document.getElementById("robbery-button");

    robberyBtn.addEventListener("click", () => {
        showingRobberies = !showingRobberies;
    
        if (showingRobberies) {
            robberyBtn.innerHTML =
                '<span class="stat-label">Services</span><span class="stat-value">Back</span>';
            fetch(`https://${GetParentResourceName()}/robberyClick`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({})
            });
        } else {
            robberyBtn.innerHTML =
                '<span class="stat-label">Robbery</span><span class="stat-value">Status</span>';
            fetch(`https://${GetParentResourceName()}/requestServices`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({})
            });            
        }
    });    
});

document.addEventListener('DOMContentLoaded', () => {
  const el = document.getElementById('server_name');
  if (!el) return;

  if (window.invokeNative) {
    fetch(`https://${GetParentResourceName()}/getServerName`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify({})
    })
      .then(r => r.json())
      .then(name => { el.textContent = name || 'Server'; })
      .catch(() => { el.textContent = 'Server'; });
  } else {
    el.textContent = 'Server (Preview)';
  }
});