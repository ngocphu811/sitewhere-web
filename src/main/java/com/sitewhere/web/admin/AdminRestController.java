package com.sitewhere.web.admin;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sitewhere.rest.model.asset.AssetModule;
import com.sitewhere.server.SiteWhereServer;
import com.sitewhere.spi.SiteWhereException;
import com.sitewhere.spi.asset.IAssetModule;

/**
 * Controller for administrative REST services.
 * 
 * @author dadams
 */
public class AdminRestController {

	/**
	 * List all asset modules.
	 * 
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/assetmodules", method = RequestMethod.GET)
	@ResponseBody
	public List<AssetModule> listAssetModules() throws SiteWhereException {
		List<AssetModule> amConverted = new ArrayList<AssetModule>();
		List<IAssetModule<?>> modules = SiteWhereServer.getInstance().getAssetModuleManager().getModules();
		for (IAssetModule<?> module : modules) {
			amConverted.add(AssetModule.copy(module));
		}
		return amConverted;
	}
}