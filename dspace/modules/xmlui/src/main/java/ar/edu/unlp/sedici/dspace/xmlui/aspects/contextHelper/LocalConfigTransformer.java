package ar.edu.unlp.sedici.dspace.xmlui.aspects.contextHelper;

import java.io.IOException;
import java.sql.SQLException;

import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.UserMeta;
import org.dspace.authorize.AuthorizeException;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.Group;
import org.xml.sax.SAXException;

public class LocalConfigTransformer extends AbstractDSpaceTransformer {

	@Override
	public void addUserMeta(UserMeta userMeta) throws SAXException,
			WingException, UIException, SQLException, IOException,
			AuthorizeException {
		
		EPerson eperson = this.context.getCurrentUser();
		if (eperson ==null)
			return;

		//Carga los grupos del usuario actualmente logueado.
		// Se coloca un grupo en por cada /document/meta/userMeta/metadata[@element='identifier' and @qualifier='group']
		for (Group g:Group.allMemberGroups(this.context, eperson)) {
			userMeta.addMetadata("identifier", "group").addContent(g.getName());
		}
				
	}
	
	
}
