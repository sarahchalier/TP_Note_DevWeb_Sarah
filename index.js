class Pokemon extends HTMLElement {
    constructor() {
        super()
        this.attachShadow({ mode: "open" });
        this.Nom = this.getAttribute("Nom");
        this.Type = this.getAttribute("Type");
        this.PV = this.getAttribute("PV");
        this.image = this.getAttribute("image");
        this.Couleur = this.getAttribute("Couleur");


        console.log("Nom : ", this.Nom)
        console.log("Type : ", this.Type)
        console.log("PV : ", this.PV)
        console.log("image : ", this.image)
        console.log("Couleur : ", this.Couleur)
    }

    connectedCallback() {
        console.log('Ui card ready');
        this.render();
    }

    render() {
        this.shadowRoot.innerHTML = `
            <style>
                :host {
                    width: calc(33.333% - 10px);
                }

                div {
                    display: flex;
                    flex-direction: column;
                    align-items: center;

                    background: #bfc0c9;
                    padding: 100px;
                    border-radius: 10px;
                    color: #060505;
                }
            </style>

            <div>
                <header>
                    <img src="" />
                </header>
                <article>
                    <p>Nom : <strong>${this.Nom}</strong></p>
                    <p>Type : <strong>${this.Type}</strong></p>
                    <p>PV : <strong>${this.PV}</strong></p>
                    <p>image : <strong>${this.image}</strong></p>
                    <p>Couleur : <strong>${this.Couleur}</strong></p>
                </article>
            </div>
        `
        
    }
}


customElements.define("ui-card", Pokemon);

class Pokeball extends HTMLElement {
}